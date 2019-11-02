//
//  BulletinBoardProtocol.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap

public protocol BulletinBoardProtocol {
    var itemType: ItemType { get }
    var message: String? { get set }
    var image: File? { get set }
}
