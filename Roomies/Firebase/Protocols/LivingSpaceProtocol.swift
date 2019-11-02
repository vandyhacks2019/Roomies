//
//  LivingSpaceProtocol.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation

protocol LivingSpaceProtocol {
    var name: String? { get set }
    var chores: [String]? { get set }
    var bills: [String]? { get set }
    var groceries: [String]? { get set }
    var residents: [String] { get set }
    var miscellaneous: [String]? { get set }
    var bulletinBoard: BulletinBoard? { get set }
}
