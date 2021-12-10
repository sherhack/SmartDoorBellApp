//
//  ViewController.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 15/11/2021.
//

import UIKit
import Firebase
import FirebaseDatabase

import AVKit
import AVFoundation
//Comment hi dude
//Comment hi dude - Rafael
//Created a branch-rafael
class ViewController: UIViewController{

    var ref: DatabaseReference!
    
 
    var isCosed: Bool = true
    var isLightOff: Bool = true
    
    @IBOutlet var buttonOpenDoor: UIButton!
    
    @IBOutlet var buttonTunLight: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
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
}


