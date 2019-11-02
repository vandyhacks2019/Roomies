//
//  Chore.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap

struct Chore: Codable, Modelable, BaseItemProtocol, ChoreProtocol {
    var itemType: ItemType = ItemType.Chore
    var name: String?
    var createdBy: String?
    var users: [String]?
    var priority: Int?
    var createdOn: Date = Date()


    init() { }

    init(name: String, createdBy: String, dueDate: Date, users: [String], priority: Int = 0) {
        self.name = name
        self.createdBy = createdBy
        self.users = users
        self.priority = priority
    }
}

