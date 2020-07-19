//
//  PresentDetailTransition.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 17/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class PresentDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let offset: CGFloat = UIDevice.current.hasNotch ? 60 : 20
    private let originalCornerRadius: CGFloat = 12.0
    private let duration = 0.6
    private var image: UIImage?
    
    weak var interactor: TransitionInteractor?
    
    var presenting = true
    var originFrame = CGRect.zero
    var finalFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toViewController = transitionContext.viewController(forKey: .to)! as? MenuDetailViewController
        if let image = toViewController?.imageHeader.image {
            self.image = image
        }
        toViewController?.imageHeader.alpha = 0
        let backgroundView = UIView(frame: containerView.frame)
        containerView.addSubview(backgroundView)
        backgroundView.backgroundColor = .customLightYellow
        backgroundView.alpha = 0
        
        let toView = transitionContext.view(forKey: .to)!
        toView.alpha = 0
        if presenting {
            toView.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
        } else {
            toView.center = CGPoint(x: originFrame.midX, y: finalFrame.midY + offset)
        }
        toView.transform = presenting ?
            CGAffineTransform(scaleX: 0.4, y: 0.4) :
            CGAffineTransform(scaleX: 0.4 * finalFrame.height / 200, y: 0.4 * finalFrame.height / 200)
        
        containerView.addSubview(toView)
        
        let cornerRadius = presenting ? 0 : originalCornerRadius
        let frame = presenting ? originFrame : finalFrame
        let endFrame = presenting ? finalFrame : originFrame
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = presenting ? originalCornerRadius : 0
        imageView.clipsToBounds = true
        imageView.alpha = 0
        containerView.addSubview(imageView)
        
        if presenting {
            
            let blurView = UIVisualEffectView(frame: frame)
            blurView.effect = UIBlurEffect(style: .light)
            blurView.alpha = 0
            blurView.layer.cornerRadius = originalCornerRadius
            blurView.clipsToBounds = true
            containerView.addSubview(blurView)
            
            UIView.animateKeyframes(withDuration: duration,
                                    delay: 0,
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                                            imageView.alpha = 1
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9) {
                                            imageView.frame = endFrame
                                            blurView.frame = endFrame
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.75) {
                                            blurView.alpha = 0.25
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                                            backgroundView.alpha = 1
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.55) {
                                            imageView.layer.cornerRadius = cornerRadius
                                            blurView.layer.cornerRadius = cornerRadius
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8) {
                                            toView.transform = .identity
                                            toView.alpha = 1
                                            toView.center = containerView.center
                                        }
            },
                                    completion: { (completed) in
                                        toViewController?.imageHeader.alpha = 1
                                        imageView.removeFromSuperview()
                                        blurView.removeFromSuperview()
                                        backgroundView.removeFromSuperview()
                                        transitionContext.completeTransition(true)
            })
        } else {
            UIView.animateKeyframes(withDuration: duration,
                                    delay: 0,
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0.01, relativeDuration: 0.01) {
                                            imageView.alpha = 1
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.8) {
                                            imageView.frame = endFrame
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                                            backgroundView.alpha = 1
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.55) {
                                            imageView.layer.cornerRadius = cornerRadius
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.7) {
                                            toView.transform = .identity
                                            toView.alpha = 1
                                            toView.center = containerView.center
                                        }
                                        UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
                                            imageView.alpha = 0
                                        }
            },
                                    completion: { (completed) in
                                        imageView.removeFromSuperview()
                                        backgroundView.removeFromSuperview()
                                        let finish = self.interactor?.shouldFinish ?? true
                                        transitionContext.completeTransition(finish)
            })
        }
    }
}
