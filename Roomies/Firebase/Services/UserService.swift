//
//  UserService.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import Ballcap
import RxSwift
import RxCocoa

class UserService {
    /// Shared instance of the UserService
    static let sharedInstance = UserService()

    /// Current AppUser
    private (set) public var appUser = ReplaySubject<AppUser>.createUnbounded()

    /// Firebase Auth instance
    private var authInstance: Auth

    /// Private initializer for singleton magic
    private init() {
        self.authInstance = Auth.auth()
    }

    /// Sign into Firebase with a email address and password
    public func signIn(email: String, password: String, completion: ((AuthorizationResult) -> ())? = nil) {
        var authResult = AuthorizationResult()

        guard let user = Auth.auth().currentUser else {
            self.authInstance.signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.updateAuthResult(authResult: &authResult, errorMessage: error.localizedDescription)
                    return
                }

                self.updateAuthResult(authResult: authResult, firebaseUser: result!.user) { authResult in
                    self.performAuthorizationResultCallback(completion, authResult: authResult)
                }
            }
            return
        }

        self.updateAuthResult(authResult: authResult, firebaseUser: user) { authResult in
            self.performAuthorizationResultCallback(completion, authResult: authResult)
        }
    }

    /// Register a new AppUser, which creates a FirebaseAuth user and an AppUser
    public func registerAppUser(email: String, password: String, fullName: String, completion: ((AuthorizationResult) -> ())? = nil) {
        var authResult = AuthorizationResult()

        self.authInstance.createUser(withEmail: email, password: password) { (result, error) in
            if let result = result {
                self.updateAuthResult(authResult: authResult, firebaseUser: result.user) { (authResult) in
                    self.performAuthorizationResultCallback(completion, authResult: authResult)
                }
            } else if let error = error {
                self.updateAuthResult(authResult: &authResult, errorMessage: error.localizedDescription)
            } else {
                self.updateAuthResult(authResult: &authResult, errorMessage: "Unknown Error")
            }
        }
    }

    /// Update the AuthorizationResult object with the AppUser data and change the success flag to true or false depending on the AppUser being nil
    private func updateAuthResult(authResult: AuthorizationResult, firebaseUser: FirebaseAuth.User, completion: @escaping (AuthorizationResult) -> ()) {
        let appUserRef = Firestore.firestore().document("/users/\(firebaseUser.uid)")
        var authResult = authResult

        appUserRef.setData(BaseUserData(firebaseUser).raw)

        authResult.firebaseUser = firebaseUser
        authResult.appUserDocument = Document(appUserRef)
        authResult.appUserDocument!.get { (document, error) in
            if error != nil || document == nil || document!.data == nil {
                authResult.success = false
                authResult.errorMessage = error!.localizedDescription
            }

            self.appUser.on(.next(document!.data!))
            self.performAuthorizationResultCallback(completion, authResult: authResult)
        }
    }

    /// Perform the optional completion helper
    private func performAuthorizationResultCallback(_ completion: ((AuthorizationResult) -> ())?, authResult: AuthorizationResult) {
        if let completion = completion {
            completion(authResult)
        }
    }

    /// Update the AuthorizationResult object with an error message and set the success flag to false
    private func updateAuthResult(authResult: inout AuthorizationResult, errorMessage: String) {
        authResult.errorMessage = errorMessage
        authResult.success = false
    }
}
