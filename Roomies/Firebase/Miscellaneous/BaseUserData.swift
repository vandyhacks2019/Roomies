//
//  BaseUserData.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import FirebaseAuth

struct BaseUserData {
    private let itemType: ItemType = .AppUser
    private var userID: String

    public var raw: [String: Any] {
        get {
            return ["userID": self.userID, "itemType": self.itemType.rawValue]
        }
    }

    init(_ firebaseUser: FirebaseAuth.User) {
        self.userID = firebaseUser.uid
    }
}
