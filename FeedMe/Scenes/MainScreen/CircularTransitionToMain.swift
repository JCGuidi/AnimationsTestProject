//
//  CircularTransition.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class CircularTransitionToMain: NSObject {

    private enum Constants {
        static let statusBarOffset: CGFloat = 22 //UIDevice.current.hasNotch ? 44 : 20
    }
    
    private var circle = UIView()
    
    var startingPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY) {
        didSet {
            circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.customGreen
    
    var duration = 0.6

    var topOffset: CGFloat = 0
}

extension CircularTransitionToMain: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        startingPoint = (transitionContext.viewController(forKey: .from) as? LogInViewController)?.logInButton.center ?? startingPoint
        let viewCenter = presentedView.center
        let viewSize = presentedView.frame.size
        
        presentedView.alpha = 0
        containerView.addSubview(presentedView)
        
        circle = UIView()
        circle.frame = frameForCircle(with: viewCenter, size: viewSize, startPoint: startingPoint)
        circle.layer.cornerRadius = circle.frame.size.height / 2
        circle.center = startingPoint
        circle.backgroundColor = circleColor
        circle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        containerView.addSubview(circle)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0.0,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.85) {
                                        self.circle.transform = CGAffineTransform.identity
                                        presentedView.transform = CGAffineTransform.identity
                                        presentedView.center = viewCenter
                                    }
        },
                                completion: { success in
                                    presentedView.alpha = 1
                                    transitionContext.completeTransition(success)
                                    self.circle.removeFromSuperview()
        }
        )
        
        
    }
    
    func frameForCircle(with viewCenter: CGPoint, size: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, size.width - startPoint.x)
        let yLength = fmax(startPoint.y, size.height - startPoint.y)
        
        let offestVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offestVector, height: offestVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
