//
//  UIDevice.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 > 0
    }
}
