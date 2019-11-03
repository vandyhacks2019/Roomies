//
//  LivingSpaceSharePage.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Ballcap

class LivingSpaceSharePage: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneSymbolButton: UIButton!
    @IBOutlet weak var doneTextButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var nameField: UITextField!

    public var setupViewController: SetupViewController?
    public var chosenAddress: PhysicalAddress?

    private var disposeBag: RxSwift.DisposeBag!
    private var alreadyCreated = false

    override func viewDidLoad() {
        self.disposeBag = DisposeBag()
        self.nameField.delegate = self
        self.setupToHideKeyboardOnTapOnView()
    }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        if let setupViewController = self.setupViewController {
            setupViewController.goToPreviousPage()
        }
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        if (!alreadyCreated) {
            self.disableInterface()
            self.createLivingSpace().subscribe { (event) in
                if let createError = event.error {
                    print(createError)
                } else if let livingSpaceDocument = event.element, let livingSpace = livingSpaceDocument.data,
                    livingSpace.address == self.chosenAddress {

                    self.performSegue(withIdentifier: "showDashboard", sender: self)
                    self.dismissViewControllers()
                }
                self.enableInterface()
            }.disposed(by: self.disposeBag)
        } else {
            self.performSegue(withIdentifier: "showDashboard", sender: self)
            self.dismissViewControllers()
        }
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        self.disableInterface()
        self.createLivingSpace().flatMap { livingSpaceDocument -> Observable<UIImage> in
            self.alreadyCreated = true
            return LivingSpaceService.sharedInstance.createShareCode(forLivingSpace: livingSpaceDocument)
        }.subscribe { (event) in
            self.enableInterface()
            if let shareCodeImage = event.element {
                self.displayShareCode(shareCodeImage)
            }
        }.disposed(by: self.disposeBag)
    }

    private func dismissViewControllers() {
        guard let vc = self.presentingViewController else { return }

        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: true, completion: nil)
        }
    }

    private func disableInterface() {
        self.doneTextButton.isEnabled = false
        self.doneSymbolButton.isEnabled = false
        self.backButton.isEnabled = false
        self.shareButton.isEnabled = false
        self.nameField.isEnabled = false
    }

    private func enableInterface() {
        self.doneTextButton.isEnabled = true
        self.doneSymbolButton.isEnabled = true
        self.backButton.isEnabled = true
        self.shareButton.isEnabled = true
        self.nameField.isEnabled = true
    }

    private func displayShareCode(_ image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: { })
    }

    private func createLivingSpace() -> Observable<Document<LivingSpace>> {
        let name = self.nameField.text

        return UserService.sharedInstance.appUser.share().distinctUntilChanged().flatMap { currentAppUser in
            return LivingSpaceService.sharedInstance.createLivingSpace(forUser: currentAppUser, name: name, address: self.chosenAddress)
        }
    }

    private func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

extension LivingSpaceSharePage: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
