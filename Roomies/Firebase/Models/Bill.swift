//
//  Bill.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap

struct Bill: Codable, Modelable, BaseItemProtocol, BillProtocol {
    var itemType: ItemType = ItemType.Bill
    var name: String?
    var createdBy: String?
    var dueDate: Date?
    var users: [String: Double]?
    var createdOn: Date = Date()

    init() { }

    init(name: String, createdBy: String, dueDate: Date, users: [String: Double]) {
        self.name = name
        self.createdBy = createdBy
        self.dueDate = dueDate
        self.users = users
    }
}

