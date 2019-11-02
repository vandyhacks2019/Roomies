//
//  AppUser.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Ballcap

struct AppUser: Modelable, Codable, AppUserProtocol {
    var itemType: ItemType = ItemType.AppUser
    var name: String?
    var profilePicture: File?
    var userID: String = ""
}
