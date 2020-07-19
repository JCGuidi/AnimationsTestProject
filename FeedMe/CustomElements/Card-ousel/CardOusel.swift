//
//  CardOusel.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 18/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

@IBDesignable
final class CardOusel: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftCard: CardView!
    @IBOutlet weak var centralCard: CardView!
    @IBOutlet weak var rightCard: CardView!
    
    private var currentOption = 0
    
    var viewModel: CardOuselViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func configure(for viewModel: CardOuselViewModel) {
        self.viewModel = viewModel
        update(for: 0, direction: .forward)
    }
    
    func show() {
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
        
        leftCard.alpha = 0
        centralCard.alpha = 0
        rightCard.alpha = 0
        
        centralCard.layer.shadowColor = UIColor.customBlack.cgColor
        centralCard.layer.shadowOpacity = 0.4
        centralCard.layer.shadowRadius = 4
        centralCard.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func update(for option: Int, direction: Direction) {
        currentOption = option
        viewModel.onOptionChange?(option, direction)
        let centerDifference = centralCard.center.x - leftCard.center.x
        let positionDiff: CGFloat = direction == .forward ? centerDifference : -centerDifference
        let selectedOption = viewModel.cardViewModels[option]
        
        centralCard.configure(for: selectedOption)
        resetCard()
        animateView(view: centralCard, delay: 0, offset: positionDiff)
        
        if option > 0 {
            let previousOption = viewModel.cardViewModels[option - 1]
            
            if option - 1 > 0 && direction == .forward {
                let aux = CardView(frame: leftCard.frame)
                aux.configure(for: viewModel.cardViewModels[option - 2])
                addSubview(aux)
                animateX(view: aux, delay: 0.1, xDiff: positionDiff, completion: { _ in
                    aux.removeFromSuperview()
                })
            }
            leftCard.configure(for: previousOption)
            leftCard.isHidden = false
            animateView(view: leftCard, delay: 0, offset: positionDiff)
        } else {
            leftCard.isHidden = true
        }
        
        if option < viewModel.cardViewModels.count - 1 {
            
            if option + 1 < viewModel.cardViewModels.count - 1 && direction == .backward {
                let aux = CardView(frame: rightCard.frame)
                aux.configure(for: viewModel.cardViewModels[option + 2])
                addSubview(aux)
                animateX(view: aux, delay: 0.1, xDiff: positionDiff, completion: { _ in
                    aux.removeFromSuperview()
                })
            }
            
            let nextOption = viewModel.cardViewModels[option + 1]
            rightCard.configure(for: nextOption)
            rightCard.isHidden = false
            animateView(view: rightCard, delay: 0, offset: positionDiff)
        } else {
            rightCard.isHidden = true
        }
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
            if !shouldRotate {
                centralCard.layer.shadowOpacity = 0
            }
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
    
    func resetCard() {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = centralCard.layer.transform
        animation.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.duration = 0.3
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
    
    func show(card: CardView) {
        let offset = centralCard.center.x - leftCard.center.x
        card.center.x += offset
        animateX(view: card, delay: 0.1, xDiff: offset)
        animateAlpha(view: card, delay: 0)
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
