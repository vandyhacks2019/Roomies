//
//  PhysicalAddressProtocol.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap

public protocol PhysicalAddressProtocol {
    var streetName: String? { get set }
    var streetNumber: String? { get set }
    var city: String? { get set }
    var state: String? { get set }
    var zipCode: String? { get set }
    var country: String? { get set }
}
