//
//  LoginViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var actionButton: UIButton!

    public var userService: UserService!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.userService = UserService.sharedInstance

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.hideKeyboard()
        sender.isEnabled = false

        do {
            let email = try self.emailAddressField.validatedText(validationType: .email)
            let password = try self.passwordField.validatedText(validationType: .password)

            self.userService.signIn(email: email, password: password) { (authResult) in
                if authResult.success {
                    print("we logged in")
                }
            }
        } catch (let error) {
            print(error)
            sender.isEnabled = true
        }
    }

    @IBAction func returnButtonTapped() {
        self.hideKeyboard()
        self.dismiss(animated: true, completion: nil)
    }

    @objc public func hideKeyboard() {
        view.endEditing(true)
    }
}
