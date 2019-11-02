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

/// UserService class for AppUser and Firebase Authentication
class UserService {
    /// Shared instance of the UserService
    static let sharedInstance = UserService()

    private var authInstance: Auth
    private var appUsersCollection: CollectionReference

    /// Current AppUser
    private (set) public var appUser = ReplaySubject<AppUser>.createUnbounded()

    /// Private initializer for singleton magic
    private init() {
        self.authInstance = Auth.auth()
        self.appUsersCollection = Firestore.firestore().collection("users")
    }

    /// Sign into Firebase with a email address and password
    public func signIn(email: String, password: String, completion: ((AuthorizationResult) -> ())? = nil) {
        var authResult = AuthorizationResult()

        guard let user = self.authInstance.currentUser else {
            self.authInstance.signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.updateAuthResult(authResult: &authResult, errorMessage: error.localizedDescription)
                    self.performOptionalCallback(completion, authResult)
                    return
                }

                self.updateAuthResult(authResult: authResult, firebaseUser: result!.user) { self.performOptionalCallback(completion, $0) }
            }
            return
        }

        self.updateAuthResult(authResult: authResult, firebaseUser: user) { self.performOptionalCallback(completion, $0) }
    }

    /// Register a new AppUser, which creates a FirebaseAuth user and an AppUser
    public func registerAppUser(email: String, password: String, fullName: String, completion: ((AuthorizationResult) -> ())? = nil) {
        var authResult = AuthorizationResult()

        self.authInstance.createUser(withEmail: email, password: password) { (result, error) in
            if let result = result {
                self.updateAuthResult(authResult: authResult, firebaseUser: result.user) { self.performOptionalCallback(completion, $0) }
            } else if let error = error {
                self.updateAuthResult(authResult: &authResult, errorMessage: error.localizedDescription)
            } else {
                self.updateAuthResult(authResult: &authResult, errorMessage: "Unknown Error")
            }
        }
    }

    /// Update an AppUser object
    public func updateAppUser(_ appUser: AppUser, completion: ((Bool) -> ())? = nil) {
        let appUserDocument = Document<AppUser>(id: appUser.userID!, collectionReference: self.appUsersCollection)

        appUserDocument.data = appUser
        appUserDocument.save() { error in
            if let error = error {
                print(error)
                self.performOptionalCallback(completion, false)
            }

            self.appUser.on(.next(appUser))
            self.performOptionalCallback(completion, true)
        }
    }

    public func deleteAppUser(_ appUser: AppUser, completion: ((Bool) -> ())? = nil) {
        let appUserDocument = Document<AppUser>(id: appUser.userID!, collectionReference: self.appUsersCollection)

        appUserDocument.delete() { error in
            if let error = error {
                print("Could not delete appuser \(error)")
                self.performOptionalCallback(completion, false)
            } else {
                self.authInstance.currentUser!.delete { (error) in
                    if let error = error {
                        print("Could not delete firebase user \(error)")
                        self.performOptionalCallback(completion, false)
                    } else {
                        self.performOptionalCallback(completion, true)
                    }
                }
            }

        }
    }

    /// Update the AuthorizationResult object with the AppUser data and change the success flag to true or false depending on the AppUser being nil
    private func updateAuthResult(authResult: AuthorizationResult, firebaseUser: FirebaseAuth.User, completion: @escaping (AuthorizationResult) -> ()) {
        let appUserDocument = Document<AppUser>(id: firebaseUser.uid, collectionReference: self.appUsersCollection)

        var authResult = authResult

        appUserDocument.get { (document, error) in
            if let document = document, let appUser = document.data {
                authResult.success = true
                authResult.appUser = appUser

                self.appUser.on(.next(document.data!))
                self.performOptionalCallback(completion, authResult)
            } else if let error = error {
                authResult.success = false
                authResult.errorMessage = error.localizedDescription

                self.appUser.on(.error(error))
                self.performOptionalCallback(completion, authResult)
            } else {
                let appUser = AppUser(userID: firebaseUser.uid)
                self.appUsersCollection.document(firebaseUser.uid).setData(from: appUser) { error in
                    if let error = error {
                        authResult.success = false
                        authResult.errorMessage = error.localizedDescription
                        self.appUser.on(.error(error))
                    } else {
                        authResult.success = true
                        authResult.appUser = appUser
                        self.appUser.on(.next(appUser))
                    }

                    self.performOptionalCallback(completion, authResult)
                }
            }
        }
    }

    /// Perform the optional completion helper
    private func performOptionalCallback<T>(_ completion: ((T) -> ())?, _ object: T) {
        if let completion = completion {
            completion(object)
        }
    }

    /// Update the AuthorizationResult object with an error message and set the success flag to false
    private func updateAuthResult(authResult: inout AuthorizationResult, errorMessage: String) {
        authResult.errorMessage = errorMessage
        authResult.success = false
    }
}
