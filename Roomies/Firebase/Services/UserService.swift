//
//  UserService.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Ballcap

struct AuthorizationResult {
    var firebaseUser: FirebaseAuth.User?
    var appUserDocument: Document<AppUser>?
    var errorMessage: String?
    var success: Bool = false

    var appUser: AppUser? {
        get {
            if let appUserDocument = self.appUserDocument {
                return appUserDocument.data
            }

            return nil
        }
    }

    init(success: Bool = false, errorMessage: String? = nil, firebaseUser: FirebaseAuth.User? = nil, appUserDocument: Document<AppUser>? = nil) {
        self.success = success
        self.errorMessage = errorMessage
        self.firebaseUser = firebaseUser
        self.appUserDocument = appUserDocument
    }
}

class UserService {
    static let sharedInstance = UserService()

    private (set) public var appUser: AppUser?

    public func signIn(completion: @escaping (AuthorizationResult) -> ()) {
        var authResult = AuthorizationResult()

        guard let user = Auth.auth().currentUser else {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    self.updateAuthResult(authResult: &authResult, errorMessage: error.localizedDescription)
                    return
                }

                self.updateAuthResult(authResult: authResult, firebaseUser: result!.user) { authResult in
                    completion(authResult)
                }
            }
            return
        }

        self.updateAuthResult(authResult: authResult, firebaseUser: user) { authResult in
            completion(authResult)
        }
    }

    private func updateAuthResult(authResult: AuthorizationResult, firebaseUser: FirebaseAuth.User, completion: @escaping (AuthorizationResult) -> ()) {
        var authResult = authResult
        let appUserRef = Firestore.firestore().document("/users/\(firebaseUser.uid)")
        appUserRef.setData(["userID": firebaseUser.uid, "itemType" : ItemType.AppUser.rawValue])

        authResult.firebaseUser = firebaseUser
        authResult.appUserDocument = Document(appUserRef)

        authResult.appUserDocument!.get { (document, error) in
            if let error = error {
                authResult.success = false
                authResult.errorMessage = error.localizedDescription
            }

            completion(authResult)
        }
    }

    private func updateAuthResult(authResult: inout AuthorizationResult, errorMessage: String) {
        authResult.errorMessage = errorMessage
        authResult.success = false
    }
}
