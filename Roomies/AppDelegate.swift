//
//  AppDelegate.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/1/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Ballcap
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    /**
     let ref: StorageReference = Storage.storage().reference().child("/a")
     let data: Data = UIImage(named: "yeet.png")!.pngData()!
     let file: File = File(ref, data: data, mimeType: .png)
     file.save { (metadata, error) in
         var appUser = appUser
         
         appUser.profilePicture = file
         UserService.sharedInstance.updateAppUser(appUser)
     }
     */


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        BallcapApp.configure(Firestore.firestore().document("version/1"))

        UserService.sharedInstance.signIn(email: "test@test.com", password: "test123")

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


}

