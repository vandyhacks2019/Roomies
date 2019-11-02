//
//  ItemType.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation

public enum ItemType: Int, Codable {
    case BaseItem = 0
    case AppUser = 1
    case Bill = 2
    case Chore = 3
    case Grocery = 4
    case MiscellaneousItem = 5
    case BulletinBoard = 6
    case LivingSpace = 7
}
