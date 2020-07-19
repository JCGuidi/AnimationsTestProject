//
//  CardView.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 17/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

public struct CardViewModel {
    let type: PaymentMethod
    let startColor: UIColor
    let endColor: UIColor
    let textColor: UIColor
}

@IBDesignable
public final class CardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var cardBackgroundView: UIView!
    @IBOutlet private weak var cardTitle: UILabel!
    @IBOutlet private weak var cardNumber: UILabel!
    @IBOutlet private weak var cardHolder: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func configure(for cardViewModel: CardViewModel) {
        
        switch cardViewModel.type {
        case .cash:
            cardTitle.text = "Cash"
            cardTitle.textColor = cardViewModel.textColor
            cardNumber.text = ""
            cardHolder.text = ""
        case .card(let viewModel):
            cardTitle.text = viewModel.name
            cardTitle.textColor = cardViewModel.textColor
            cardNumber.text = viewModel.number
            cardNumber.textColor = cardViewModel.textColor
            cardHolder.text = viewModel.holder
            cardHolder.textColor = cardViewModel.textColor
        }
        
        setGradient(withStartColor: cardViewModel.startColor, endColor: cardViewModel.endColor)
    }
}

private extension CardView {
    func commonInit() {
        Bundle(for: type(of: self)).loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = self.bounds
        contentView.isUserInteractionEnabled = false
        
        cardBackgroundView.layer.cornerRadius = 12
        cardBackgroundView.clipsToBounds = true
    }
    
    func setGradient(withStartColor startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 12
        gradientLayer.colors = [
            startColor.cgColor,
            endColor.cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradientLayer.frame = cardBackgroundView.frame
        gradientLayer.masksToBounds = true
        
        for case let layer as CAGradientLayer in cardBackgroundView.layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        
        cardBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
