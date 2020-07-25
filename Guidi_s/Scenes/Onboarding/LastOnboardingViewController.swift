//
//  LastOnboardingViewController.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 24/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class LastOnboardingViewController: UIViewController {
    
    @IBOutlet private weak var topImage: UIImageView!
    
    private let rightGesture = UIScreenEdgePanGestureRecognizer()
    private var tossing: TossingBehavior?
    private var animator: UIDynamicAnimator!
    
    //MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGesture()
        configureAnimator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animator.removeAllBehaviors()
        tossing = TossingBehavior(item: topImage, snapTo: topImage.center)
        animator.addBehavior(tossing!)
    }
    
    //MARK: IBActions
    
    @IBAction func readyButtonTap(_ sender: Any) {
        guard let parentViewController = tabBarController as? OnboardingViewController else { return }
        parentViewController.finishTap()
    }
}

//MARK: - Private Methods

private extension LastOnboardingViewController {
    
    func configureAnimator() {
        animator = UIDynamicAnimator(referenceView: view)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(animatorPanned))
        topImage.addGestureRecognizer(panGesture)
        topImage.isUserInteractionEnabled = true
    }
    
    @objc
    func animatorPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            tossing?.isEnabled = false
        case .changed:
            let translation = recognizer.translation(in: view)
            topImage.center = CGPoint(x: topImage.center.x + translation.x,
                                      y: topImage.center.y + translation.y)
            recognizer.setTranslation(.zero, in: view)
            
        case .ended, .cancelled, .failed:
            tossing?.isEnabled = true
        default:
            break
        }
    }
    
    //MARK: Next Screen Gesture Configuration
    
    func configureGesture() {
        rightGesture.edges = .right
        rightGesture.addTarget(self, action: #selector(rightPan))
        view.addGestureRecognizer(rightGesture)
    }
    
    @objc
    func rightPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            readyButtonTap(sender)
        default:
            return
        }
    }
}
