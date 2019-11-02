//
//  AuthorizationResult.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap
import FirebaseAuth

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
