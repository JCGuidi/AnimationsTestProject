//
//  MaskLayer.swift
//  AlphaTransition
//
//  Created by Juan Cruz Guidi on 21/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

enum MaskCreator {
    static func createPathFor(bounds: CGRect, waveCenterY: CGFloat, waveHorRadius: CGFloat, sideWidth: CGFloat, reversed: Bool = false) -> CGPath {
        let path = CGMutablePath()
        let maskWidth = bounds.width - sideWidth
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: maskWidth, y: bounds.height))
        
        path.addQuadCurve(to: CGPoint(x: maskWidth, y: 0), control: CGPoint(x: maskWidth - waveHorRadius, y: waveCenterY))
        
        path.closeSubpath()
        
        let mirror = CGAffineTransform(scaleX: -1, y: 1)
        let translate = CGAffineTransform(translationX: bounds.width, y: 0)
        var concatenated = mirror.concatenating(translate)
        
        return reversed ? path.mutableCopy(using: &concatenated)! : path
    }
}
