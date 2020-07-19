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
    
    enum Constants {
        enum Box {
            static let height: CGFloat = 100
            static let cornerRadius: CGFloat = 4
            static let borderWidth: CGFloat = 1
            static let zPerspective: CGFloat = 1400
        }
        enum Replicator {
            static let height: CGFloat = 200
        }
    }
    
    private(set) var viewModel: CheckoutViewModel!
    
    func configure(for viewModel: CheckoutViewModel) {
        self.viewModel = viewModel
        viewModel.onOrderSuccess = { [unowned self] in
            self.setUpFinalAnimation()
        }
    }
    
    //MARK: ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cardOusel.show()
        updateUI(for: 0, direction: .forward, completeAnimation: false)
    }
    
    //MARK: IBActions
    
    @IBAction func dissmisButtonTap(_ sender: Any) {
        viewModel.handleDismissTap()
    }
    
    @IBAction func handleOrderNow(_ sender: Any) {
        startOrderingAnimation()
    }
}

//MARK: - Private Methods

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
            self.viewModel.handleOrderNowTap()
        })
    }
    
    //MARK: Box Animation Methods
    
    func setUpFinalAnimation() {
        let boxBottom = UIView(frame: CGRect(x: view.center.x - Constants.Box.height / 2,
                                             y: -Constants.Box.height * 1.1,
                                             width: Constants.Box.height,
                                             height: Constants.Box.height))
        let boxBottomLayer = CAShapeLayer()
        boxBottomLayer.path = UIBezierPath(
            roundedRect: boxBottom.bounds,
            cornerRadius: Constants.Box.cornerRadius
        ).cgPath
        boxBottomLayer.strokeColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        boxBottomLayer.lineWidth = 3
        boxBottomLayer.fillColor = UIColor.white.cgColor
        boxBottomLayer.borderColor = UIColor.lightGray.cgColor
        boxBottomLayer.borderWidth = Constants.Box.borderWidth
        boxBottom.layer.addSublayer(boxBottomLayer)
    
        translucidView.addSubview(boxBottom)
        translucidView.sendSubviewToBack(boxBottom)
        
        let boxTop = UIView(frame: boxBottom.frame)
        let boxTopLayer = CALayer()
        boxTopLayer.frame = boxTop.bounds
        boxTopLayer.contents = UIImage(named: "smallIcon")?.cgImage
        boxTopLayer.cornerRadius = Constants.Box.cornerRadius
        boxTopLayer.masksToBounds = true
        boxTopLayer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        boxTopLayer.borderWidth = Constants.Box.borderWidth
        
        boxTop.layer.addSublayer(boxTopLayer)
        boxTop.layer.shouldRasterize = true
        boxTop.layer.rasterizationScale = UIScreen.main.scale
        
        translucidView.addSubview(boxTop)
        
        boxTop.center.y -= Constants.Box.height / 2
        boxTop.layer.anchorPoint.y = 0
        var identity = CATransform3DIdentity
        identity.m34 = -1.0/Constants.Box.zPerspective
        let rotationTransform = CATransform3DRotate(identity, .pi / 3, 1, 0, 0)
        boxTop.layer.transform = rotationTransform
        
        doFinalAnimation(WithBoxTop: boxTop, boxBottom: boxBottom)
    }
    
    func doFinalAnimation(WithBoxTop boxTop: UIView, boxBottom: UIView) {
        
        let label = thankYouLabel()
        label.center.x = view.center.x
        translucidView.addSubview(label)
        
        let button = restartButton()
        button.alpha = 0
        translucidView.addSubview(button)
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            boxBottom.center = self.view.center
            boxTop.center.y = self.view.center.y - 50
        })
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
            boxTop.layer.transform = CATransform3DIdentity
        }) { _ in
            self.replicatorView.removeFromSuperview()
        }
        UIView.animate(withDuration: 1, delay: 1.5, options: .curveEaseInOut, animations: {
            boxBottom.center.y += self.view.bounds.height
            boxTop.center.y += self.view.bounds.height
            label.center.y = self.view.center.y
        }) { _ in
            button.alpha = 1
            boxBottom.removeFromSuperview()
            boxTop.removeFromSuperview()
        }
    }
    
    @objc
    func restartTap() {
        viewModel.handleRestartTap()
    }
    
    //MARK: Replicator
    
    func setUpReplicator(in view: UIView) {
        let duration = 0.5
        let pizzaSlices = 7
        let pizza = CALayer()
        let replicator = CAReplicatorLayer()
        
        replicatorView = UIView(frame: CGRect(x: view.center.x - Constants.Replicator.height / 2,
                                              y: view.center.y - Constants.Replicator.height / 2,
                                              width: Constants.Replicator.height,
                                              height: Constants.Replicator.height))
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
        replicator.instanceCount = pizzaSlices
        replicator.instanceTransform = CATransform3DMakeRotation(.pi * 2 / CGFloat(pizzaSlices), 0, 0, 1)
        replicator.instanceDelay = duration
        
        pizza.addSpring(animationKeyPath: "transform.scale", fromValue: 0.4, toValue: 1, duration: duration)
        pizza.add(animationKeyPath: "opacity", fromValue: 0, toValue: 1, duration: duration)
    }
}

//MARK: - Private Helper Methods

private extension CheckoutViewController {
    
    func thankYouLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: -200, width: 200, height: 200))
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
    
    func animateLabel<T: UILabel>(label: T, newText: String, delay: Double, offset: CGFloat, withHelper: Bool = true) {
        if withHelper {
            let titleAuxLabel = T(frame: label.frame)
            titleAuxLabel.font = label.font
            titleAuxLabel.textColor = label.textColor
            titleAuxLabel.text = label.text
            titleAuxLabel.numberOfLines = label.numberOfLines
            
            view.addSubview(titleAuxLabel)
            titleAuxLabel.animateAlpha(withDelay: delay, duration: 0.5, finalValue: 0)
            titleAuxLabel.animateX(withDelay: delay + 0.1, xDiff: offset, completion: { _ in
                titleAuxLabel.removeFromSuperview()
            })
        }
        
        label.alpha = 0
        label.center.x += offset
        label.text = newText
        
        label.animateAlpha(withDelay: delay, duration: 0.5)
        label.animateX(withDelay: delay + 0.1, xDiff: offset)
    }
}
