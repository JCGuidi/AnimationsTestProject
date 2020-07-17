//
//  CheckoutViewController.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 17/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class CheckoutViewController: UIViewController {

    @IBOutlet private weak var paymentMethodView: UIView!
    @IBOutlet private weak var infoTitle: UILabel!
    @IBOutlet private weak var infoDescription: UILabel!
    @IBOutlet private weak var cardView: CardView!
    
    enum Direction {
        case forward
        case backward
    }
    
    private var currentOption = 0
    
    var viewModel: CheckoutViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI(for: 1, direction: .forward, completeAnimation: false)
    }
    
    @IBAction func dissmisButtonTap(_ sender: Any) {
        viewModel.handleDismissTap()
    }
}

private extension CheckoutViewController {
    
    func configureUI() {
        infoTitle.alpha = 0
        infoDescription.alpha = 0
        cardView.alpha = 0
        cardView.layer.cornerRadius = 12
        cardView.backgroundColor = .gray
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        paymentMethodView.addGestureRecognizer(pan)
    }
    
    @objc
    func didPan(_ recognizer: UIPanGestureRecognizer) {
        let threshold: CGFloat = 0.5
        let translation = recognizer.translation(in: paymentMethodView)
        let coeficient = translation.x/UIScreen.main.bounds.width

        var identity = CATransform3DIdentity
        identity.m34 = -1.0/1000
        
        let angle =  coeficient * .pi * 0.5
        
        let rotationTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
        cardView.layer.transform = rotationTransform
        switch recognizer.state {
        case .began:
            cardView.layer.shouldRasterize = true
            cardView.layer.rasterizationScale =
              UIScreen.main.scale
        case .changed:
            if coeficient > threshold {
                guard currentOption > 0 else { return }
                self.updateUI(for: currentOption - 1, direction: .backward)
                recognizer.state = .ended
            } else if coeficient < -threshold {
                guard currentOption < viewModel.paymentMethods.count - 1 else { return }
                self.updateUI(for: currentOption + 1, direction: .forward)
                recognizer.state = .ended
            }
        case .ended:
            resetCard()
        default:
            break
        }
    }
    
    func resetCard() {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = cardView.layer.transform
        animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.duration = 0.33
        cardView.layer.add(animation, forKey: nil)
        cardView.layer.transform = CATransform3DIdentity
    }
    
    func updateUI(for option: Int, direction: Direction, completeAnimation: Bool = true) {

        let infoForOption = viewModel.paymentMethods[option]
        currentOption = option
        
        let width = paymentMethodView.bounds.width
        let positionDiff: CGFloat = direction == .forward ? width : -width
        
        cardView.set(title: infoForOption.name, number: infoForOption.description)
        cardView.setGradient(withStartColor: infoForOption.startColor, endColor: infoForOption.endColor)
        
        animateLabel(label: infoTitle,
                     newText: infoForOption.informationTitle,
                     delay: 0,
                     offset: positionDiff,
                     withHelper: completeAnimation)
        
        animateLabel(label: infoDescription,
                     newText: infoForOption.information,
                     delay: 0.1,
                     offset: positionDiff,
                     withHelper: completeAnimation)
        animateView(view: cardView, delay: 0, offset: positionDiff, withHelper: completeAnimation)
    }
    
    func animateView<T: UIView>(view: T, delay: Double, offset: CGFloat, withHelper: Bool = true) {
        if withHelper {
            let auxView = T(frame: view.frame)
            paymentMethodView.addSubview(auxView)
            animateAlpha(view: auxView, delay: delay, finalValue: 0)
            animateX(view: auxView, delay: delay + 0.1, xDiff: offset, completion: { _ in
                auxView.removeFromSuperview()
            })
        }
        
        view.alpha = 0
        view.center.x += offset
        
        animateAlpha(view: view, delay: delay)
        animateX(view: view, delay: delay + 0.1, xDiff: offset)
    }
    
    func animateLabel<T: UILabel>(label: T, newText: String, delay: Double, offset: CGFloat, withHelper: Bool = true) {
        if withHelper {
            let titleAuxLabel = T(frame: label.frame)
            titleAuxLabel.font = label.font
            titleAuxLabel.textColor = label.textColor
            titleAuxLabel.text = label.text
            
            view.addSubview(titleAuxLabel)
            animateAlpha(view: titleAuxLabel, delay: delay, finalValue: 0)
            animateX(view: titleAuxLabel, delay: delay + 0.1, xDiff: offset, completion: { _ in
                titleAuxLabel.removeFromSuperview()
            })
        }
        
        label.alpha = 0
        label.center.x += offset
        label.text = newText
        
        animateAlpha(view: label, delay: delay)
        animateX(view: label, delay: delay + 0.1, xDiff: offset)
    }
    
    func animateX<T: UIView>(view: T, delay: Double, xDiff: CGFloat, completion:((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.1,
                       options: [],
                       animations: {
                        view.center.x -= xDiff
        }, completion: completion)
    }
    
    func animateAlpha<T: UIView>(view: T, delay: Double, finalValue: CGFloat = 1, completion:((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: [],
                       animations: {
                        view.alpha = finalValue
        }, completion: completion)
    }
}

