//
//  AppDelegate.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 15/11/2021.
//

import UIKit
import UIKit
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureUserNotifications()
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    private func configureUserNotifications() {
        UNUserNotificationCenter.current().delegate = self
    }
    

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.banner)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
            return
        }
        
    
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate the view controller from storyboard
        /*if  let liveStreamVC = storyboard.instantiateViewController(withIdentifier: "LiveStreamView") as? LiveStreamViewController {

            rootViewController = liveStreamVC
            // set the view controller as root
           
            rootViewController.navigationController?.pushViewController(liveStreamVC, animated: true)
            

        }*/
        
        let rootViewControlle = rootViewController as! UINavigationController
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "LiveStreamView") as! LiveStreamViewController
            rootViewControlle.pushViewController(profileViewController, animated: true)
        
        
        completionHandler()
    }
    
    

}
