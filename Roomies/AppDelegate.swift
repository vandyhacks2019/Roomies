//
//  AppDelegate.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/1/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Ballcap
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        BallcapApp.configure(Firestore.firestore().document("version/1"))
        
        
        return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
      
   //     config.storyboard = (Auth.auth().currentUser != nil ? UIStoryboard(name: "Authorized", bundle: nil) : UIStoryboard(name: "LoginRegister", bundle: nil))
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: .windowApplication)
    }

}

