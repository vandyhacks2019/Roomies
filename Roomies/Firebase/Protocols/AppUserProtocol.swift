//
//  AppUserProtocol.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Ballcap
import FirebaseFirestore

public protocol AppUserProtocol {
    var name: String? { get set }
    var profilePicture: File? { get set }
    var userID: String? { get }
    var livingSpaceAddresses: [PhysicalAddress]? { get set }
}
