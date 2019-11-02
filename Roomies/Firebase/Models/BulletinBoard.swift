//
//  BulletinBoard.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap

struct BulletinBoard: Codable, Modelable, BulletinBoardProtocol {
    var itemType: ItemType = ItemType.BulletinBoard
    var message: String?
    var image: File?
}
