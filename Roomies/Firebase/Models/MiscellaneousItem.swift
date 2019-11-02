//
//  MiscellaneousItem.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap

struct MiscellaneousItem: Codable, Modelable, BaseItemProtocol, CommentedItemProtocol {
    var itemType: ItemType = ItemType.MiscellaneousItem
    var name: String?
    var createdBy: String = ""
    var comment: String?
    var createdOn: ServerTimestamp = ServerTimestamp.pending

    init() { }

    init(name: String, createdBy: String, comment: String = "") {
        self.name = name
        self.createdBy = createdBy
        self.comment = comment
    }
}
