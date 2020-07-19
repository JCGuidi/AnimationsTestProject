//
//  CardOuselDelegate.swift
//  CardOusel
//
//  Created by Juan Cruz Guidi on 19/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

public protocol CardOuselDelegate: AnyObject {
    func cardOusel(_ cardOusel: CardOusel, didChangeTo option: Int, withDirection direction: Direction)
}
