//
//  DetailCellViewModel.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 17/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

struct DetailCellViewModel {
    let name: String
    let imageName: String
    let ingredients: String
    var isOnCart: Bool
    let addActionHandler: (() -> Void)?
    let removeActionHandler: (() -> Void)?
}
