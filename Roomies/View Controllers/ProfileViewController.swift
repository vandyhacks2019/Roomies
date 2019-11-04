//
//  ProfileViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/3/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ProfileViewController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var profileImageButton: UIButton!

    private var appUser: AppUser!
    private var disposeBag: RxSwift.DisposeBag!
    
    override func viewDidLoad() {
        self.disposeBag = DisposeBag()
        UserService.sharedInstance.appUser.share().distinctUntilChanged()
            .bind { appUser in
                self.appUser = appUser
                
                if let fullName = appUser.name {
                    self.fullNameField.text = fullName
                }
                
                if let profilePicture = appUser.profilePicture {
                    profilePicture.getData { (data, error) in
                        if let pictureData = data {
                            self.profileImageButton.setImage(UIImage(data: pictureData), for: .normal)
                        }
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }

    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.appUser.name = self.fullNameField.text!
        
        UserService.sharedInstance.updateAppUser(self.appUser)
    }
}
