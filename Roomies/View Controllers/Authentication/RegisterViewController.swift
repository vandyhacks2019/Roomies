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

            self.userService.registerAppUser(email: email, password: password, fullName: fullName!) {
                self.handleRegister(authResult: $0)
            }
        } catch (let error) {
            self.showErrorAlert(message: (error as! ValidationError).message)
            sender.isEnabled = true
        }
    }

    @IBAction func returnLoginButtonTapped() {
        self.hideKeyboard()
        self.dismiss(animated: true, completion: nil)

        if (self.presentingViewController as? RegisterViewController) == nil {
            self.presentingViewController!.present(RegisterViewController.instantiate(fromAppStoryboard: .PreLogin), animated: true)
        }
    }

    private func handleRegister(authResult: AuthorizationResult) {
        var viewController: UIViewController!

        if authResult.success, let appUser = authResult.appUser, appUser.livingSpaceAddresses == nil {
            viewController = AppStoryboard.Setup.viewController(viewControllerClass: SetupViewController.self)
        } else if authResult.success {
            viewController = AppStoryboard.Main.viewController(viewControllerClass: UITabBarController.self)
        }

        if viewController != nil {
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        } else {
            self.showErrorAlert(message: "Incorrect email address or password")
        }
    }

    @objc public func hideKeyboard() {
        view.endEditing(true)
    }
}
