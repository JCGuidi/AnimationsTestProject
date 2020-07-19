//
//  CALayer+Animations.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 18/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import QuartzCore

extension CALayer {
    func addSpring(animationKeyPath: String, fromValue: Double, toValue: Double, duration: Double) {
        let animation = CASpringAnimation(keyPath: animationKeyPath)
        animation.damping = 4
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        animation.repeatCount = 1
        self.add(animation, forKey: nil)
    }
    
    func add(animationKeyPath: String, fromValue: Double, toValue: Double, duration: Double) {
        let animation = CABasicAnimation(keyPath: animationKeyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        animation.repeatCount = 1
        self.add(animation, forKey: nil)
    }
}
