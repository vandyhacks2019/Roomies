//
//  BaseItemProtocol.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Ballcap
import FirebaseFirestore

protocol BaseItemProtocol {
    var itemType: ItemType { get }
    var name: String? { get set }
    var createdBy: String { get set }
    var createdOn: ServerTimestamp { get }
}
