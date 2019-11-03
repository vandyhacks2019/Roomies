//
//  DummyDashboardViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import FirebaseAuth

class DummyDashboardViewController: UIViewController {
    private var signOutSubscription: Disposable?
    
    @IBAction func logoutCurrentUser() {
        self.signOutSubscription = UserService.sharedInstance.signOut().subscribe { event in
            if let signOutError = event.error {
                print(signOutError)
            } else if let didSignOut = event.element, didSignOut {
                self.performSegue(withIdentifier: "returnToInitial", sender: self)
            }
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if let signOutSubscription = self.signOutSubscription {
            signOutSubscription.dispose()
        }
    }
}
