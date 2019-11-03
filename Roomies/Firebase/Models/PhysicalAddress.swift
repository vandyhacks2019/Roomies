//
//  PhysicalAddress.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import Ballcap
import Contacts

public struct PhysicalAddress: Codable, Modelable, PhysicalAddressProtocol {
    public var street: String?
    public var city: String?
    public var state: String?
    public var zipCode: String?
    public var country: String?

    public init() { }
    
    public var queryValue: [String: String] {
        get {
            guard let data = try? JSONEncoder().encode(self) else { return [String: String]() }
            return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: String] }!
        }
    }
    
    init(fromPostalAddress postalAddress: CNPostalAddress) {
        self.street = postalAddress.street
        self.city = postalAddress.city
        self.state = postalAddress.state
        self.country = postalAddress.country
        self.zipCode = postalAddress.postalCode
    }
}
