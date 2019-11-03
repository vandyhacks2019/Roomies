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

class DashboardViewController: UITableViewController {
    private var userService: UserService!
    private var disposeBag: RxSwift.DisposeBag!

    override func viewDidLoad() {
        self.configureNavigationBar()

        self.disposeBag = DisposeBag()
        self.userService = UserService.sharedInstance
        self.userService.appUser.share().distinctUntilChanged().bind { (appUser) in
            //      self.title = "Welcome, \(appUser.name!)"
            print(appUser)
        }.disposed(by: self.disposeBag)
    }


    private func configureNavigationBar() {
        let appearance = navigationController?.navigationBar.standardAppearance.copy()
        
        appearance?.shadowColor = .clear
        navigationItem.standardAppearance = appearance
    }
}
