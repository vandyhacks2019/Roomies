//
//  LivingSpace.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap

struct LivingSpace: Codable, Modelable, BaseItemProtocol, LivingSpaceProtocol {
    // MARK - Weak Properties
    var chores: [String]?
    var bills: [String]?
    var groceries: [String]?
    var miscellaneous: [String]?
    var bulletinBoard: BulletinBoard?
    var name: String?
    var address: PhysicalAddress?

    // MARK - Strong Properties
    var createdOn: ServerTimestamp = ServerTimestamp.pending
    var residents: [String] = []
    var itemType: ItemType = ItemType.LivingSpace
    var createdBy: String = ""
    
    init() { }

    init(name: String, createdBy: String, address: PhysicalAddress? = nil) {
        self.name = name
        self.createdBy = createdBy
        self.residents = [createdBy]
        self.address = address
    }
}
