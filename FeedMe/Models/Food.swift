//
//  Food.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 16/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

struct Food {
    let name: String
    let imageName: String
    var ingredients: String = ""
}

struct FoodCategory {
    let title: String
    let imageName: String
    let food: [Food]
}
