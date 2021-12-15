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


class LiveStreamViewController: UIViewController, WKNavigationDelegate{
    
  
    var ref: DatabaseReference! = Database.database().reference()

    
    @IBOutlet var switchOutlet: UISwitch!
    @IBOutlet var live: WKWebView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        reload()
    }
  
    
    @IBAction func sendMessageButton(_ sender: Any) {
        
        let text: String = messageTextField.text!
        
        print(text)
        
        ref.child("Audio")//child("Leds/led1")
        
        ref.updateChildValues([
            "value": 1,
            "phrase": text
        ])
       
       
        
    }
    @IBAction func switchDoor(_ sender: UISwitch) {
        ref.child("Door")//child("Leds/led1")
    
        
        if switchOutlet.isOn {
            ref.updateChildValues([
                "value": 1
            ])
            switchOutlet.setOn(true, animated:true)
            self.showToast(message: "Door Opened", font: .systemFont(ofSize: 12.0))
        } else {
            ref.updateChildValues([
                "value": 0
            ])
            switchOutlet.setOn(false, animated:true)
            self.showToast(message: "Door Closed", font: .systemFont(ofSize: 12.0))
        }
       
    }
   


  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func reload() {
        ref.child("Refresh")//child("Leds/led1")
        ref.observe(DataEventType.childChanged) { DataSnapshot in
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

}
