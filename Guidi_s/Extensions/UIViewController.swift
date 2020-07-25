//
//  UIViewController.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiate<T>(from storyboard: String = AppConstants.mainStoryboard) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: .main)
        let controller = storyboard.instantiateViewController(identifier: "\(T.self)") as! T
        return controller
    }
}
