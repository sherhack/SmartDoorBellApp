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
    
    let url = URL(string: "http://10.20.246.120:8080/?action=stream")!
    
    
    
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
        viewWebLive = WKWebView(frame: CGRect( x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 350 ), configuration: WKWebViewConfiguration() )
           self.view.addSubview(viewWebLive)
        viewWebLive.load(URLRequest(url: url))
           self.viewWebLive.allowsBackForwardNavigationGestures = true
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        
        ref = Database.database().reference().child("Audio")//child("Leds/led1")
        
        ref.updateChildValues([
            "value": 1
        ])
       
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

}
