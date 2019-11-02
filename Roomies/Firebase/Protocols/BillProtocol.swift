//
//  BillProtocol.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Ballcap
import FirebaseFirestore

public protocol BillProtocol {
    var dueDate: Date? { get set }
    var users: [String: Double]? { get set }
}
