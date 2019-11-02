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
    private var appUserSubscription: Disposable?
    private var createLivingSpaceSubscription: Disposable?

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

        self.appUserSubscription = UserService.sharedInstance.appUser.subscribe { (event: Event) in
            if let appUser = event.element {
                print("AppUser \(appUser)")

                var livingSpaceAddress = PhysicalAddress()
                livingSpaceAddress.streetNumber = "69"
                livingSpaceAddress.streetName = "Mary Jane Ln."
                livingSpaceAddress.city = "Denver"
                livingSpaceAddress.state = "CO"
                livingSpaceAddress.zipCode = "69420"
                livingSpaceAddress.country = "United States of America"
                
                self.createLivingSpaceSubscription = LivingSpaceService.sharedInstance
                    .createLivingSpace(forUser: appUser, name: "Test Living Space", address: livingSpaceAddress)
                    .catchError({ (error) -> Observable<Document<LivingSpace>> in
                        return LivingSpaceService.sharedInstance.fetchLivingSpace(forAddress: livingSpaceAddress)
                    })
                    .subscribe { (createEvent) in
                        if let createError = createEvent.error {
                            print("Error: \(createError)")
                        } else if let livingSpaceDocument = createEvent.element, let livingSpace = livingSpaceDocument.data {
                            print("LivingSpace \(livingSpace)")
                        } else {
                            print(event)
                        }
                        self.createLivingSpaceSubscription?.dispose()

                }
                
                

            } else if let error = event.error {
                print("Error \(error)")
            } else {
                print(event)
            }

            self.appUserSubscription!.dispose()
        }

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

