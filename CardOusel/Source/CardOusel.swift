//
//  CardOusel.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 18/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

@IBDesignable
public final class CardOusel: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftCard: CardView!
    @IBOutlet weak var centralCard: CardView!
    @IBOutlet weak var rightCard: CardView!
    
    public var delegate: CardOuselDelegate?
    
    private var currentOption = 0
    
    var viewModel: CardOuselViewModel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public func configure(for viewModel: CardOuselViewModel) {
        self.viewModel = viewModel
        update(for: 0, direction: .forward)
    }
    
    public func show() {
        guard viewModel != nil else { fatalError("No data was set to show on the CardOusel - use `configure(for:)`") }
        show(card: centralCard)
        show(card: leftCard)
        show(card: rightCard)
    }
}

//MARK: - Private Methods

private extension CardOusel {
    func commonInit() {
        Bundle(for: type(of: self)).loadNibNamed("CardOusel", owner: self, options: nil)
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = self.bounds
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.addGestureRecognizer(pan)
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(selectLeft))
        leftCard.addGestureRecognizer(leftTap)
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(selectRight))
        rightCard.addGestureRecognizer(rightTap)
        
        leftCard.alpha = 0
        centralCard.alpha = 0
        rightCard.alpha = 0
        
        centralCard.layer.shadowColor = UIColor.customBlack.cgColor
        centralCard.layer.shadowOpacity = 0.4
        centralCard.layer.shadowRadius = 4
        centralCard.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    //MARK: UI Update Methods
    
    func update(for option: Int, direction: Direction) {
        guard viewModel != nil else { fatalError("No data was set to show on the CardOusel - use `configure(for:)`") }
        currentOption = option
        delegate?.cardOusel(self, didChangeTo: option, withDirection: direction)
        
        let centerDifference = centralCard.center.x - leftCard.center.x
        let positionDiff: CGFloat = direction == .forward ? centerDifference : -centerDifference
        let selectedOption = viewModel.cardViewModels[option]
        
        centralCard.configure(for: selectedOption)
        animateView(view: centralCard, delay: 0, offset: positionDiff)
        
        handleLeftCard(for: option, direction: direction, positionDiff: positionDiff)
        handleRightCard(for: option, direction: direction, positionDiff: positionDiff)
    }
    
    func handleLeftCard(for option: Int, direction: Direction, positionDiff: CGFloat) {
        guard let previousOption = viewModel.cardViewModels[safe: option - 1] else {
            leftCard.isHidden = true
            return
        }
        leftCard.configure(for: previousOption)
        leftCard.isHidden = false
        animateView(view: leftCard, delay: 0, offset: positionDiff)
        
        if direction == .forward, let auxOption = viewModel.cardViewModels[safe: option - 2] {
            setAuxiliarCard(for: leftCard, withViewModel: auxOption, positionDiff: positionDiff)
        }
    }
    
    func handleRightCard(for option: Int, direction: Direction, positionDiff: CGFloat) {
        guard let nextOption = viewModel.cardViewModels[safe: option + 1] else {
            rightCard.isHidden = true
            return
        }
        rightCard.configure(for: nextOption)
        rightCard.isHidden = false
        animateView(view: rightCard, delay: 0, offset: positionDiff)
        
        if direction == .backward, let auxOption = viewModel.cardViewModels[safe: option + 2] {
            setAuxiliarCard(for: rightCard, withViewModel: auxOption, positionDiff: positionDiff)
        }
    }
    
    func setAuxiliarCard(for cardView: CardView, withViewModel viewModel: CardViewModel, positionDiff: CGFloat) {
        let aux = CardView(frame: cardView.frame)
        aux.configure(for: viewModel)
        addSubview(aux)
        animateX(view: aux, delay: 0.1, xDiff: positionDiff, completion: { _ in
            aux.removeFromSuperview()
        })
    }
    
    //MARK: Change Options Logic
    
    @objc
    func selectLeft() {
        update(for: currentOption - 1, direction: .backward)
    }
    
    @objc
    func selectRight() {
        update(for: currentOption + 1, direction: .forward)
    }
    
    @objc
    func didPan(_ recognizer: UIPanGestureRecognizer) {
        let threshold: CGFloat = 0.15
        let translation = recognizer.translation(in: self)
        let coeficient = translation.x/self.bounds.width
        let direction: Direction = coeficient > 0 ? .backward : .forward
        let shouldRotate = direction == .forward ? currentOption == viewModel.cardViewModels.count - 1 : currentOption == 0
        
        switch recognizer.state {
        case .began:
            centralCard.layer.shouldRasterize = true
            centralCard.layer.rasterizationScale = UIScreen.main.scale
            if !shouldRotate { centralCard.layer.shadowOpacity = 0 }
        case .changed:
            if shouldRotate {
                var identity = CATransform3DIdentity
                identity.m34 = -1.0/1000
                let angle =  coeficient * .pi * 0.5
                let rotationTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0)
                centralCard.layer.transform = rotationTransform
            } else {
                centralCard.layer.shadowOpacity = 0
            }
            
            guard !shouldRotate, abs(coeficient) > threshold else { return }
            recognizer.state = .ended
            let newIndex = currentOption + (direction == .backward ? -1 : 1)
            self.update(for: newIndex, direction: direction)
        case .ended:
            if shouldRotate { resetCard() }
            addShadowToCentralCard()
        default:
            break
        }
    }
    
    //MARK: Animation Methods
    
    func show(card: CardView) {
        let offset = centralCard.center.x - leftCard.center.x
        card.center.x += offset
        animateX(view: card, delay: 0.1, xDiff: offset)
        animateAlpha(view: card, delay: 0)
    }
    
    func resetCard() {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = centralCard.layer.transform
        animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        centralCard.layer.add(animation, forKey: nil)
        centralCard.layer.transform = CATransform3DIdentity
    }
    
    func addShadowToCentralCard() {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = centralCard.layer.shadowOpacity
        animation.toValue = 0.4
        animation.duration = 0.5
        centralCard.layer.add(animation, forKey: nil)
        centralCard.layer.shadowOpacity = 0.4
    }
    
    func animateView<T: UIView>(view: T, delay: Double, offset: CGFloat) {
        view.center.x += offset
        animateX(view: view, delay: delay + 0.1, xDiff: offset)
    }
    
    func animateAlpha<T: UIView>(view: T, delay: Double, finalValue: CGFloat = 1, completion:((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: [],
                       animations: {
                        view.alpha = finalValue
        }, completion: completion)
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
}
