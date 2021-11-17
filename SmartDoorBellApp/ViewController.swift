//
//  ViewController.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 15/11/2021.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    var ref: DatabaseReference!

 


    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

   
}

