//
//  Cart.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 16/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

final class Cart {
    static let shared = Cart()
    
    private(set) var orders: Set<String> = []
    
    private init() {}
    
    func add(newOrder: String) {
        orders.insert(newOrder)
    }
    
    func remove(order: String) {
        orders.remove(order)
    }
    
    func empty() {
        orders.removeAll()
    }
}
