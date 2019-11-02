//
//  RegisterViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: LoginViewController {
    @IBOutlet weak var fullNameField: UITextField?
    @IBOutlet weak var confirmPasswordField: UITextField?
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        self.hideKeyboard()
        sender.isEnabled = false

        do {
            let email = try self.emailAddressField.validatedText(validationType: .email)
            let password = try self.passwordField.validatedText(validationType: .password)
            let repeatedPassword = try self.passwordField.validatedText(validationType: .password)
            let fullName = try self.fullNameField?.validatedText(validationType: .requiredField(field: "Full Name"))

            if password != repeatedPassword {
                throw ValidationError("Passwords do not match")
            }

            self.userService.registerAppUser(email: email, password: password, fullName: fullName!) { (authResult) in
                if authResult.success {
                    self.performSegue(withIdentifier: "showDashboard", sender: self)
                }
            }
        } catch (let error) {
            print(error)
            sender.isEnabled = true
        }
    }

}
