//
//  InitialViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift

class InitialViewController: UIViewController {
    private var currentUserSubscription: Disposable?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let firebaseUser = Auth.auth().currentUser {
            self.currentUserSubscription = UserService.sharedInstance.appUser.distinctUntilChanged().subscribe { event in
                    if let appUser = event.element, let uid = appUser.userID, uid == firebaseUser.uid {
                        self.disposeUserSubscription()
                        if let addresses = appUser.livingSpaceAddresses, addresses.count > 0 {
                            self.showDashboard()
                        } else {
                            self.showCreateLivingSpaceView()
                        }
                    } else {
                        self.disposeUserSubscription()
                        self.showRegisterView()
                    }
            }
            
            UserService.sharedInstance.validateAppUser(forFirebaseUser: firebaseUser)
        } else {
            self.showRegisterView()
        }
    }
    
    private func showRegisterView() {
        self.performSegue(withIdentifier: "showRegister", sender: self)
    }
    
    private func showCreateLivingSpaceView() {
        self.performSegue(withIdentifier: "showCreateLivingSpace", sender: self)
    }
    
    private func showDashboard() {
        self.performSegue(withIdentifier: "showDashboard", sender: self)
    }
    
    private func disposeUserSubscription() {
        if let currentUserSubscription = self.currentUserSubscription {
            currentUserSubscription.dispose()
        }
    }
}
