//
//  BaseItem.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/1/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap

struct BaseItem: Codable, Modelable, BaseItemProtocol {
    var itemType: ItemType = ItemType.BaseItem
    var name: String?
    var createdBy: String?
    var createdOn: Date = Date()
    
    init() {}
    
    init(name: String, createdBy: String) {
        self.name = name
        self.createdBy = createdBy
    }
}
