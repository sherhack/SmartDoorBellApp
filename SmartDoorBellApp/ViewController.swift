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

import AVKit
import AVFoundation
//Comment hi dude
//Comment hi dude - Rafael
//Created a branch-rafael
class ViewController: UIViewController{

    var ref: DatabaseReference!
    
    @IBOutlet var labelDate: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    var isCosed: Bool = true
    var isLightOff: Bool = true
    
    @IBOutlet var buttonOpenDoor: UIButton!
    
    @IBOutlet var buttonTunLight: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLastImage()
       
       
        // Do any additional setup after loading the view.
    }
   

    @IBAction func closeDoor(_ sender: Any) {
        if isCosed == true {
            ref = Database.database().reference().child("Door")//child("Leds/led1")
            
            ref.updateChildValues([
                "value": 1
            ])
            buttonOpenDoor.setTitle("Door Open", for: .normal)
            
            isCosed = false
        } else {
            ref = Database.database().reference().child("Door")//child("Leds/led1")
            
            ref.updateChildValues([
                "value": 0
            ])
            buttonOpenDoor.setTitle("Door Closed", for: .normal)
            
            isCosed = true
        }
        
    }
    
    @IBAction func turnLight(_ sender: Any) {
        if isLightOff == true {
            ref = Database.database().reference().child("Light")
            
            ref.updateChildValues([
                "value": 1
            ])
            buttonTunLight.setTitle("Light On", for: .normal)
            isLightOff = false
        } else {
            ref = Database.database().reference().child("Light")
            
            ref.updateChildValues([
                "value": 0
            ])
            buttonTunLight.setTitle("Light off", for: .normal)
            isLightOff = true
        }
    }
    
    func addImage() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let ref = storageRef.child("images").child("photo_2021_12_10_12_02_54.jpg")
       

     
        imageView.sd_setImage(with: ref)
        
     
    }
    
    func getLastImage() {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("images")
        
        var yourArray = [StorageReference]()
        
        storageRef.listAll { [self] (result, error) in
            if let error = error {
                // ...
            }
            for prefix in result.prefixes {
                // The prefixes under storageReference.
                // You may call listAll(completion:) recursively on them.
                print("Prefixessssssss:  \(prefix)")
            }
            for item in result.items {
                // The items under storageReference.
                print("ITEMMMMM: \(item)")
                //var image: StorageReference?
                guard var image: StorageReference? = item else { return }
                //print("AHAHAHAHAHHAHAAAH: \(String(describing: image?.name.suffix(29)))")
                var name = String(describing: image?.name.suffix(29))
                //var year = name[NSRange(location: 7, length: 4)]
                
                print(getDate(image: image!.name))
                labelDate.text = getDate(image: image!.name)
                
                yourArray.append(image!)
            }
            imageView.sd_setImage(with: yourArray.last!)
        }

    }
    
    func getDate(image: String) -> String {

    var lowerBound = image.index((image.startIndex), offsetBy: 6)
    var upperBound = image.index((image.startIndex), offsetBy: 10)
    var year = image[lowerBound..<upperBound]



    lowerBound = image.index((image.startIndex), offsetBy: 11)
    upperBound = image.index((image.startIndex), offsetBy: 13)
    var month = image[lowerBound..<upperBound]

    lowerBound = image.index((image.startIndex), offsetBy: 14)
    upperBound = image.index((image.startIndex), offsetBy: 16)
    var day = image[lowerBound..<upperBound]

    lowerBound = image.index((image.startIndex), offsetBy: 17)
    upperBound = image.index((image.startIndex), offsetBy: 19)
    var hour = image[lowerBound..<upperBound]

    lowerBound = image.index((image.startIndex), offsetBy: 20)
    upperBound = image.index((image.startIndex), offsetBy: 22)
    var minute = image[lowerBound..<upperBound]

    lowerBound = image.index((image.startIndex), offsetBy: 23)
    upperBound = image.index((image.startIndex), offsetBy: 25)
    var second = image[lowerBound..<upperBound]




    // making string in date formate "YYYY-MM-DD h:m:s"



    let dateString = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second
    return dateString
    }
    
   
    
}


