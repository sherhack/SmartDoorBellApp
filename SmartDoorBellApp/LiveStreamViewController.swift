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
    
    var ref: DatabaseReference!
    
    @IBOutlet var switchOutlet: UISwitch!
    @IBOutlet var live: WKWebView!
    
    let url = URL(string: "http://10.20.246.120:8080/?action=stream")! //http://10.20.246.120:8080/?action=stream")!
    
    
    @IBOutlet var messageTextField: UITextField!
    
    var viewWebLive: WKWebView! /*{
        didSet {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(reload(_:)), for: .valueChanged)
            viewWebLive.scrollView.refreshControl = refreshControl
        }
       
    }*/
    
    
    
    /*
    override func loadView() {
      /*
        let webConfiguration = WKWebViewConfiguration()
             webView = WKWebView(frame: .zero, configuration: webConfiguration)
             webView.uiDelegate = self
             view = webView
       */
        
        viewWebLive = WKWebView()
        viewWebLive.navigationDelegate = self
        view = viewWebLive
        
        
    }*/
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let url = URL(string: "http://10.20.246.120:8080/?action=stream")!
       
         viewWebLive.load(URLRequest(url: url))
         viewWebLive.allowsBackForwardNavigationGestures = true
       
        /*
        let myURL = URL(string:"http://10.20.246.120:8080/?action=stream")
               let myRequest = URLRequest(url: myURL!)
               webView.load(myRequest)
            
        }*/
     
    }*/
    
    override func viewDidLoad() {
           super.viewDidLoad()
        /*
        viewWebLive = WKWebView(frame: CGRect( x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 420 /*350*/ ), configuration: WKWebViewConfiguration() )
           self.view.addSubview(viewWebLive)
        viewWebLive.load(URLRequest(url: url))
           self.viewWebLive.allowsBackForwardNavigationGestures = true*/
        
        
           //self.view.addSubview(viewWebLive)
        live.load(URLRequest(url: url))
        live.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        live.allowsBackForwardNavigationGestures = true
        live.navigationDelegate = self
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        
        let text: String = messageTextField.text!
        
        print(text)
        
        ref = Database.database().reference().child("Audio")//child("Leds/led1")
        
        ref.updateChildValues([
            "value": 1,
            "phrase": text
        ])
       
       
        
    }
    @IBAction func switchDoor(_ sender: UISwitch) {
        ref = Database.database().reference().child("Door")//child("Leds/led1")
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    func reloadData() {
        //All you need to update
        
    }*/
    
    /*
    func reloadButtonDidTap(_ url : URL) {
        if viewWebLive.url != nil {
            viewWebLive.reload()
        } else {
            viewWebLive.load(URLRequest(url: url))
        }
    }*/
    
    /*
    @objc private func reload(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        viewWebLive.reload()
    }*/

  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

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
