//
//  PaymentMethod.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 18/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

public enum PaymentMethod {
    case cash
    case card(CardModel)
}

public struct CardModel {
    let name: String
    let holder: String
    let number: String
}
