//
//  PaymentMethod.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 18/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

enum PaymentMethod {
    case cash
    case card(CardModel)
}

struct CardModel {
    let name: String
    let holder: String
    let number: String
}
