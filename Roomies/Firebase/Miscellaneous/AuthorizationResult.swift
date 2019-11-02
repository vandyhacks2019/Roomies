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
    var appUser: AppUser?
    var errorMessage: String?
    var success: Bool = false

    init(success: Bool = false, errorMessage: String? = nil, firebaseUser: FirebaseAuth.User? = nil, appUser: AppUser? = nil) {
        self.success = success
        self.errorMessage = errorMessage
        self.firebaseUser = firebaseUser
        self.appUser = appUser
    }
}
