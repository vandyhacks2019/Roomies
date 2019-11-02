//
//  LivingSpaceItem.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/1/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import ObjectMapper

class LivingSpaceItem: Mappable {
    var name: String?
    var createdBy: String?
    var createdOn: Date?

    func mapping(map: Map) {
        name <- map["name"]
        createdBy <- map["createdBy"]
        createdOn <- map["createdOn"]
    }

    required init?(map: Map) { }
}
