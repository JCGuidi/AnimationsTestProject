//
//  Array+SafeIndex.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 19/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
