//
//  LiveStreamViewController.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 03/12/2021.
//

import UIKit
import AVFoundation
import AVKit
import WebKit

import Firebase
import FirebaseDatabase



class LiveStreamViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {
    
  
    var ref: DatabaseReference!

    var storageRef: StorageReference!
    
    @IBOutlet var imageViewDoor: UIImageView!
    
    @IBOutlet var switchOutlet: UISwitch!
    
    @IBOutlet var live: WKWebView!
    
    @IBOutlet var messageTextField: UITextField!
    
    var viewWebLive: WKWebView!
    
    var screenShot = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        storageRef = Storage.storage().reference()
    
        ref.child("RaspberryIP").observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            let ip = value?["value"] as? String ?? ""
            print("Value: \(ip)")
            
            let url = URL(string: "http://\(ip):8080/?action=stream")!
        
            self.live.load(URLRequest(url: url))
            self.live.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.live.allowsBackForwardNavigationGestures = true
            self.live.navigationDelegate = self
        });
        
        self.messageTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
         
        // call the 'keyboardWillShow' function when the view controller receive notification that keyboard is going to be shown
            NotificationCenter.default.addObserver(self, selector: #selector(LiveStreamViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
           NotificationCenter.default.addObserver(self, selector: #selector(LiveStreamViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        ref.child("Door").observeSingleEvent(of: .value, with: { snapshot in
             
             let value = snapshot.value as? NSDictionary
             let valueDoor = value?["value"] as? Int ?? 0
             print("Value: \(valueDoor)")
             if valueDoor == 1 {
                 self.switchOutlet.setOn(true, animated:true)
                 self.imageViewDoor.image = UIImage(named: "doorOpen")
             } else {
                 self.switchOutlet.setOn(false, animated:true)
                 self.imageViewDoor.image = UIImage(named: "doorClosed")
             }
             
            
         });
        
        reload()
    
    }
  
    
    @IBAction func sendMessageButton(_ sender: Any) {
        
        let text: String = messageTextField.text!
        
        print(text)
        
        //ref.child("Audio")//child("Leds/led1")
        
        ref.child("Audio").updateChildValues([
            "phrase": text,
            "value": 1
        ])
        self.showToast(message: "Message Sent", font: .systemFont(ofSize: 12.0))
       
       
        
    }
    @IBAction func switchDoor(_ sender: UISwitch) {
        if switchOutlet.isOn {
            ref.child("Door").updateChildValues([
                "value": 1
            ])
            switchOutlet.setOn(true, animated:true)
            imageViewDoor.image = UIImage(named: "doorOpen")
            self.showToast(message: "Door Opened", font: .systemFont(ofSize: 12.0))
        } else {
            ref.child("Door").updateChildValues([
                "value": 0
            ])
            switchOutlet.setOn(false, animated:true)
            imageViewDoor.image = UIImage(named: "doorClosed")
            self.showToast(message: "Door Closed", font: .systemFont(ofSize: 12.0))
        }
       
    }
   

    
    func reload() {
        ref.child("Refresh").observe(DataEventType.childChanged) { DataSnapshot in
            self.live.reload()
        }
    }

    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        DispatchQueue.main.asyncAfter(deadline:.now() + 5.0, execute: {
            
            if segue.identifier == "ShowOcrView",
                let destinationVC = segue.destination as? TextRecognitionViewController {
                destinationVC.jj = self.screenShot
            }
    
        })
    }*/
    
   //layer.frame.size
   
    
    func captureScreenshot() -> UIImage! {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: layer.bounds.width, height: 370), false, scale);

        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        //let cropedImage = cropImage(screenshot!, viewWidth: layer.bounds.width, viewHeight: layer.bounds.height)
        
        UIGraphicsEndImageContext()
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        return screenshot
    }
    
    
    @IBAction func takeScreenShotAndSave(_ sender: Any) {
        screenShot = self.captureScreenshot()
        self.showToast(message: "Taking screenshot...", font: .systemFont(ofSize: 12.0))
        
       
        guard let imageData = screenShot.pngData() else {
            return
        }
        
        //Send screenshot to firestore
        uploadScreenShotToFirestoreStorage(imageData, screenShot)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ocrView") as! TextRecognitionViewController
            
            vc.imageRecieved = self.screenShot
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
  
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
    }
    
    func uploadScreenShotToFirestoreStorage(_ pngData: Data, _ screenshot: UIImage) {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        
        let imageName:String = String("\(timestamp).png")
        
        if let uploadData = screenshot.jpegData(compressionQuality: 0.5) {
            storageRef.child("orders/").child(imageName).putData(uploadData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("Failed to upload")
                    return
                }
            })
        }

            
    }
    
    /*
    func cropImage(_ inputImage: UIImage, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let sideLength = min(
            inputImage.size.width,
            inputImage.size.height
        )

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = inputImage.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral
        
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)

        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x,
                              y:cropRect.origin.y,
                              width:cropRect.size.width ,
                              height:cropRect.size.height)

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }*/
}


