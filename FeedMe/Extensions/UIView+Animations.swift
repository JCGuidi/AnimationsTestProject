//
//  UIView+Animations.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 19/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

extension UIView {
    func animateX(withDelay delay: Double,
                  xDiff: CGFloat,
                  completion:((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.1,
                       options: [],
                       animations: {
                        self.center.x -= xDiff
        }, completion: completion)
    }
    
    func animateAlpha(withDelay delay: Double,
                      duration: Double,
                      finalValue: CGFloat = 1,
                      completion:((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: [],
                       animations: {
                        self.alpha = finalValue
        }, completion: completion)
    }
}
