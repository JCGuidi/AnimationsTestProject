//
//  CheckoutViewController.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 17/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class CheckoutViewController: UIViewController {

    @IBOutlet private weak var orderList: UILabel!
    @IBOutlet private weak var infoTitle: UILabel!
    @IBOutlet private weak var infoDescription: UILabel!
    @IBOutlet private weak var cardOusel: CardOusel!
    @IBOutlet private weak var orderNowButton: UIButton!
    @IBOutlet private var paymentMethodViewHeight: NSLayoutConstraint!

    private var translucidView = UIView()
    private var replicatorView = UIView()
    
    var viewModel: CheckoutViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cardOusel.show()
        updateUI(for: 0, direction: .forward, completeAnimation: false)
    }
    
    @IBAction func dissmisButtonTap(_ sender: Any) {
        viewModel.handleDismissTap()
    }
    
    @IBAction func handleOrderNow(_ sender: Any) {
        startOrderingAnimation()
    }
}

private extension CheckoutViewController {
    
    func configureUI() {
        let cardOuselViewModel = CardOuselViewModel(onOptionChange: { [unowned self] (option, direction) in
            self.updateUI(for: option, direction: direction)
        })
        cardOusel.configure(for: cardOuselViewModel)
        
        infoTitle.alpha = 0
        infoDescription.alpha = 0
        
        orderList.text = viewModel.orderList
    }
    
    func updateUI(for option: Int, direction: Direction, completeAnimation: Bool = true) {
        
        let width: CGFloat = UIScreen.main.bounds.width
        let positionDiff: CGFloat = direction == .forward ? width : -width
        let currentInformation = viewModel.getInformationFor(option: option)
        
        animateLabel(label: infoTitle,
                     newText: currentInformation.title,
                     delay: 0,
                     offset: positionDiff,
                     withHelper: completeAnimation)
        
        animateLabel(label: infoDescription,
                     newText: currentInformation.subtitle,
                     delay: 0.1,
                     offset: positionDiff,
                     withHelper: completeAnimation)
    }
    
    func startOrderingAnimation() {
        translucidView = UIView(frame: view.bounds)
        translucidView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        translucidView.alpha = 0
        view.addSubview(translucidView)
        UIView.animate(withDuration: 0.4, animations: {
            self.translucidView.alpha = 1
        }, completion: { _ in
            self.setUpReplicator(in: self.translucidView)
            self.doBoxAnimation()
        })
    }
    
    func doBoxAnimation() {
        let boxBottom = UIView(frame: CGRect(x: view.bounds.width / 2 - 50, y: -100, width: 100, height: 100))
        let boxLayer = CAShapeLayer()
        
        boxLayer.path = UIBezierPath(roundedRect: boxBottom.bounds, cornerRadius: 4).cgPath
        boxLayer.strokeColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        boxLayer.lineWidth = 3
        boxLayer.fillColor = UIColor.white.cgColor
        boxLayer.borderColor = UIColor.lightGray.cgColor
        boxLayer.borderWidth = 1
        boxBottom.layer.addSublayer(boxLayer)
    
        let boxTop = UIView(frame: boxBottom.frame)
        
        let imageLayer = CALayer()
        imageLayer.frame = boxTop.bounds
        imageLayer.contents = UIImage(named: "smallIcon")?.cgImage
        imageLayer.cornerRadius = 4
        imageLayer.masksToBounds = true
        imageLayer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        imageLayer.borderWidth = 1
        
        boxTop.layer.addSublayer(imageLayer)
        boxTop.layer.shouldRasterize = true
        boxTop.layer.rasterizationScale = UIScreen.main.scale
        
        translucidView.addSubview(boxBottom)
        translucidView.addSubview(boxTop)
        translucidView.sendSubviewToBack(boxBottom)
        
        boxTop.center.y -= 50
        boxTop.layer.anchorPoint.y = 0
        var identity = CATransform3DIdentity
        identity.m34 = -1.0/1400
        let rotationTransform = CATransform3DRotate(identity, .pi / 3, 1, 0, 0)
        boxTop.layer.transform = rotationTransform
        
        let label = thankYouLabel()
        label.center.x = view.center.x
        label.center.y = -100
        translucidView.addSubview(label)
        
        let button = restartButton()
        button.alpha = 0
        translucidView.addSubview(button)
        
        UIView.animate(withDuration: 1, delay: 3, options: .curveEaseInOut, animations: {
            boxBottom.center = self.view.center
            boxTop.center.y = self.view.center.y - 50
        })
        
        UIView.animate(withDuration: 0.5, delay: 4, options: .curveEaseOut, animations: {
            boxTop.layer.transform = CATransform3DIdentity
        }) { _ in
            self.replicatorView.removeFromSuperview()
        }
        UIView.animate(withDuration: 1, delay: 4.5, options: .curveEaseInOut, animations: {
            boxBottom.center.y += self.view.bounds.height
            boxTop.center.y += self.view.bounds.height
            label.center.y = self.view.center.y
        }) { _ in
            button.alpha = 1
            boxBottom.removeFromSuperview()
            boxTop.removeFromSuperview()
        }
    }
    
    func thankYouLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Thank you!"
        label.font = UIFont(name: "Rockwell-Bold", size: 50)
        return label
    }
    
    func restartButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: view.center.x - 50, y: view.center.y + 200, width: 100, height: 50))
        button.setTitle("Restart", for: .normal)
        button.addTarget(self, action: #selector(restartTap), for: .touchUpInside)
        return button
    }
    
    @objc
    func restartTap() {
        viewModel.handleRestartTap()
    }
    
    func setUpReplicator(in view: UIView) {
        let duration = 0.5
        let pizza = CALayer()
        let replicator = CAReplicatorLayer()
        
        replicatorView = UIView(frame: CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 100, width: 200, height: 200))
        view.addSubview(replicatorView)
        replicator.frame = replicatorView.bounds
        replicatorView.layer.addSublayer(replicator)
        
        let width: CGFloat = 40
        
        pizza.frame = CGRect(
            x: replicator.position.x - 4,
            y: replicator.position.y - 20,
            width: width,
            height: width)
        
        pizza.transform = CATransform3DMakeRotation(.pi / 2, 0, 0, 1)
        pizza.contents = UIImage(named: "pizza")?.cgImage
        pizza.opacity = 0
        replicator.addSublayer(pizza)
        replicator.instanceCount = 7
        replicator.instanceTransform = CATransform3DMakeRotation(.pi * 2 / 7, 0, 0, 1)
        replicator.instanceDelay = 0.5
        
        pizza.add(animationKeyPath: "transform.scale", fromValue: 0.5, toValue: 1, duration: duration)
        pizza.add(animationKeyPath: "opacity", fromValue: 0, toValue: 1, duration: duration)
        
    }
    
}

extension CALayer {
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

private extension CheckoutViewController {
    func animateLabel<T: UILabel>(label: T, newText: String, delay: Double, offset: CGFloat, withHelper: Bool = true) {
        if withHelper {
            let titleAuxLabel = T(frame: label.frame)
            titleAuxLabel.font = label.font
            titleAuxLabel.textColor = label.textColor
            titleAuxLabel.text = label.text
            titleAuxLabel.numberOfLines = label.numberOfLines
            
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
