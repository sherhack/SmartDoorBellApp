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

    
    @IBOutlet var imageViewDoor: UIImageView!
    
    @IBOutlet var switchOutlet: UISwitch!
    
    @IBOutlet var live: WKWebView!
    
    var screenShot = UIImage()
    
    //let url = URL(string: "http://10.20.246.120:8080/?action=stream")!
    
    
    @IBOutlet var messageTextField: UITextField!
    
    var viewWebLive: WKWebView!
    
    
    
  
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
    }*/
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
        
    }*/
    
//    Para vir com o valor para meter no switch
    /*override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("Door").observeSingleEvent(of: .value, with: { snapshot in
             
             let value = snapshot.value as? NSDictionary
             let valueDoor = value?["value"] as? String ?? ""
             print("Value: \(valueDoor)")
             if valueDoor == "1" {
                 self.switchOutlet.setOn(true, animated:true)
             } else {
                 self.switchOutlet.setOn(false, animated:true)
             }
             
             
         });
        self.view.reloadInputViews()
        
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    
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
                 self.imageViewDoor.image = UIImage(named: "doorClose")
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
            imageViewDoor.image = UIImage(named: "doorClose")
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
        UIGraphicsEndImageContext()
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        return screenshot
    }
    
    
    @IBAction func takeScreenShotAndSave(_ sender: Any) {
        screenShot = self.captureScreenshot()
        self.showToast(message: "Taking screenshot...", font: .systemFont(ofSize: 12.0))
        

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
    
}
