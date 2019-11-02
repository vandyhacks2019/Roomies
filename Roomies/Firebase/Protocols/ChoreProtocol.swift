//
//  ChoreProtocol.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import FirebaseFirestore
import Ballcap

protocol ChoreProtocol {
    var priority: Int? { get set }
    var users: [String]? { get set }
}
