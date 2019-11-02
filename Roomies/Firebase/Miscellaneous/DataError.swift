//
//  DataError.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation

protocol LocalizedDescriptionError: Error {
    var localizedDescription: String { get }
}

public enum DataError: LocalizedDescriptionError {
    case uniqueConstraintsError(message: String)
    case emptyArrayError(message: String)

    var localizedDescription: String {
        switch self {
        case .uniqueConstraintsError(message: let message):
            return "Cannot create item: \(message)"
        case .emptyArrayError(message: let message):
            return "Array is empty: \(message)"
        }
    }
}
