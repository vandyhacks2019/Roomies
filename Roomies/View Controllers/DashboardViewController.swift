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
    @IBOutlet weak var titleLabel: UILabel!

    private var userService: UserService!
    private var disposeBag: RxSwift.DisposeBag!

    private var showingBarTitleLabel = false
    private var contentOffset: CGFloat = 0 {
        didSet {

            if self.contentOffset >= 50, !self.showingBarTitleLabel {
                self.showingBarTitleLabel = true
                UIView.animate(withDuration: 0.5) {
                    self.navigationItem.titleView!.alpha = 1.0
                }
            } else if self.contentOffset < 50, self.showingBarTitleLabel {
                UIView.animate(withDuration: 0.5) {
                    self.showingBarTitleLabel = false
                    self.navigationItem.titleView!.alpha = 0.0
                }
            }
        }
    }

    override func viewDidLoad() {
        self.configureNavigationBar()

        self.tableView.delegate = self
        self.disposeBag = DisposeBag()
        self.userService = UserService.sharedInstance
        if let currentUser = Auth.auth().currentUser {
            self.userService.validateAppUser(forFirebaseUser: currentUser) { (authResult) in
                if let appUser = authResult.appUser {
                    self.titleLabel.text = (appUser.name != nil ? "Welcome, \(appUser.name!)" : "Dashboard")
                    (self.navigationItem.titleView as! UILabel).text = (appUser.name != nil ? "Welcome, \(appUser.name!)" : "Dashboard")
                }
            }
        }
    }


    private func configureNavigationBar() {
        let barTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        barTitleLabel.textAlignment = .center
        barTitleLabel.text = self.title
        barTitleLabel.alpha = 0.0

        let appearance = navigationController?.navigationBar.standardAppearance.copy()

        appearance?.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.titleView = barTitleLabel
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffset = scrollView.contentOffset.y
    }
}


