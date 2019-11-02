//
//  ObjectMapper+Firebase.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/1/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import ObjectMapper
import Firebase

extension BaseMappable {
    static var firebaseIdKey : String {
        get {
            return "FirebaseIdKey"
        }
    }
    init?(snapshot: DataSnapshot) {
        guard var json = snapshot.value as? [String: Any] else {
            return nil
        }
        json[Self.firebaseIdKey] = snapshot.key as Any
        
        self.init(JSON: json)
    }
}

extension Mapper {
    func mapArray(snapshot: DataSnapshot) -> [N] {
        return snapshot.children.map { (child) -> N? in
            if let childSnap = child as? DataSnapshot {
                return N(snapshot: childSnap)
            }
            return nil
            //flatMap here is a trick
            //to filter out `nil` values
            }.flatMap { $0 }
    }
}
