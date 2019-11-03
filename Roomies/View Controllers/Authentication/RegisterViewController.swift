//
//  RegisterViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField?
    @IBOutlet weak var confirmPasswordField: UITextField?

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

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        self.hideKeyboard()
        sender.isEnabled = false

        do {
            let fullName = try self.fullNameField?.validatedText(validationType: .requiredField(field: "Full Name"))
            let email = try self.emailAddressField.validatedText(validationType: .email)
            let password = try self.passwordField.validatedText(validationType: .password)
            let repeatedPassword = try self.passwordField.validatedText(validationType: .password)

            if password != repeatedPassword {
                throw ValidationError("Passwords do not match")
            }

            self.userService.registerAppUser(email: email, password: password, fullName: fullName!) { (authResult) in
                if authResult.success, let appUser = authResult.appUser, appUser.livingSpaceAddresses == nil {
                    self.showCreateLivingSpace()
                } else if authResult.success {
                    self.showDashboard()
                }
            }
        } catch (let error) {
            self.showErrorAlert(message: (error as! ValidationError).message)
            sender.isEnabled = true
        }
    }

    private func showDashboard() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showDashboard", sender: self)
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func showCreateLivingSpace() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showCreateLivingSpace", sender: self)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func returnLoginButtonTapped() {
        self.hideKeyboard()
        if (self.presentingViewController as? LoginViewController) == nil {
            let storyboard = UIStoryboard(name: "Keaton", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(identifier: "Login")

            self.present(loginViewController, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc public func hideKeyboard() {
        view.endEditing(true)
    }
}
