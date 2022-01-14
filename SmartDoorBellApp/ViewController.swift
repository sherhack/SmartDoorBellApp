//
//  ViewController.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 15/11/2021.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI
import SDWebImage

import UserNotifications
import AVKit
import AVFoundation
//Comment hi dude
//Comment hi dude - Rafael
//Created a branch-rafael
class ViewController: UIViewController {

    var ref: DatabaseReference!
    var storage: Storage!
    
    @IBOutlet var labelDate: UILabel!
    
    @IBOutlet var isLigthSwitch: UISwitch!
    @IBOutlet var isDoorSwitch: UISwitch!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var imageViewDoor: UIImageView!
    @IBOutlet var imageViewLigth: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        storage = Storage.storage()
        
//        labelDate.text = ""
        
        //getLastImage()
       
        let center = UNUserNotificationCenter.current()
        
        ref.child("Refresh").observe(DataEventType.childChanged) { DataSnapshot in
            
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            }
            
            //sTEP 2: Create notification content
            let content = UNMutableNotificationContent()
            content.title = "RING, RING!"
            content.body = "Someone is at the door!"
            
            //Step3: Creat trigger
            let date = Date().addingTimeInterval(1)
            
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day,
                                                                    .hour, .minute, .second], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //Step 4: create the request
            let uuidString = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            //Step 5: Register the request
            center.add(request) { error in
                //handle error
                print(error ?? "-")
            }
            self.getLastImage()
            
        }
        
       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        ref.child("Door").observeSingleEvent(of: .value, with: { snapshot in
             
             let value = snapshot.value as? NSDictionary
             let valueDoor = value?["value"] as? Int ?? 0
             print("Value: \(valueDoor)")
             if valueDoor == 1 {
                 self.isDoorSwitch?.setOn(true, animated:true)
                 self.imageViewDoor?.image = UIImage(named: "doorOpen")
             } else {
                 self.isDoorSwitch?.setOn(false, animated:true)
                 self.imageViewDoor?.image = UIImage(named: "doorClosed")
             }
             
            
         });
        
        ref.child("Light").observeSingleEvent(of: .value, with: { snapshot in
             
             let value = snapshot.value as? NSDictionary
             let valueDoor = value?["value"] as? Int ?? 0
             print("Value: \(valueDoor)")
             if valueDoor == 1 {
                 self.isLigthSwitch?.setOn(true, animated:true)
                 self.imageViewLigth?.image = UIImage(named: "bulbOn")
             } else {
                 self.isLigthSwitch?.setOn(false, animated:true)
                 self.imageViewLigth?.image = UIImage(named: "bulbOff")
             }
             
            
         });
        
        getLastImage()
    }
   

    @IBAction func switchDoorAction(_ sender: Any) {
        //ref = Database.database().reference().child("Door")
    
        ref.keepSynced(true)
        
        if isDoorSwitch.isOn {
            ref.child("Door").updateChildValues([
                "value": 1
            ])
            isDoorSwitch.setOn(true, animated:true)
            imageViewDoor.image = UIImage(named: "doorOpen")
            self.showToast(message: "Door Opened", font: .systemFont(ofSize: 12.0))
        } else {
            ref.child("Door").updateChildValues([
                "value": 0
            ])
            isDoorSwitch.setOn(false, animated:true)
            imageViewDoor.image = UIImage(named: "doorClosed")
            self.showToast(message: "Door Closed", font: .systemFont(ofSize: 12.0))
        }
    }
    
    @IBAction func switchLigthAction(_ sender: Any) {
        //ref = Database.database().reference().child("Light")
        
        ref.keepSynced(true)
        
        if isLigthSwitch.isOn {
            ref.child("Light").updateChildValues([
                "value": 1
            ])
            isLigthSwitch.setOn(true, animated:true)
            imageViewLigth.image = UIImage(named: "bulbOn")
            self.showToast(message: "Light On", font: .systemFont(ofSize: 12.0))
        } else {
            ref.child("Light").updateChildValues([
                "value": 0
            ])
            isLigthSwitch.setOn(false, animated:true)
            imageViewLigth.image = UIImage(named: "bulbOff")
            self.showToast(message: "Light Off", font: .systemFont(ofSize: 12.0))
        }
        
    }
    
    func getLastImage() {
        let storageRef = storage.reference().child("images")
        
        var yourArray = [StorageReference]()
        
        storageRef.listAll { [self] (result, error) in
            if let error = error {
                print(error)
            }
            for prefix in result.prefixes {
                // The prefixes under storageReference.
                // You may call listAll(completion:) recursively on them.
                print("Prefixessssssss:  \(prefix)")
            }
            for item in result.items {
                // The items under storageReference.
                //print("ITEMMMMM: \(item)")
                //var image: StorageReference?
                guard var image: StorageReference? = item else { return }
                //print("AHAHAHAHAHHAHAAAH: \(String(describing: image?.name.suffix(29)))")
                //var name = String(describing: image?.name.suffix(29))
                //var year = name[NSRange(location: 7, length: 4)]
                
               // print(getDate(image: image!.name))
                labelDate?.text = "Photo taken on last ring" + "\n" + "\(getDate(image: image!.name))"
                
                yourArray.append(image!)
            }
            imageView?.sd_setImage(with: yourArray.last!)
        }

    }
    
    func getDate(image: String) -> String {

        var lowerBound = image.index((image.startIndex), offsetBy: 6)
        var upperBound = image.index((image.startIndex), offsetBy: 10)
        let year = image[lowerBound..<upperBound]



        lowerBound = image.index((image.startIndex), offsetBy: 11)
        upperBound = image.index((image.startIndex), offsetBy: 13)
        let month = image[lowerBound..<upperBound]

        lowerBound = image.index((image.startIndex), offsetBy: 14)
        upperBound = image.index((image.startIndex), offsetBy: 16)
        let day = image[lowerBound..<upperBound]

        lowerBound = image.index((image.startIndex), offsetBy: 17)
        upperBound = image.index((image.startIndex), offsetBy: 19)
        let hour = image[lowerBound..<upperBound]

        lowerBound = image.index((image.startIndex), offsetBy: 20)
        upperBound = image.index((image.startIndex), offsetBy: 22)
        let minute = image[lowerBound..<upperBound]

        lowerBound = image.index((image.startIndex), offsetBy: 23)
        upperBound = image.index((image.startIndex), offsetBy: 25)
        let second = image[lowerBound..<upperBound]




    // making string in date formate "YYYY-MM-DD h:m:s"



        let dateString = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second
        return dateString
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
    
    
    
   
    
}


