//
//  BadgedButton.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class BadgedButton: UIButton {

    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var badgetLabel: UILabel!
    @IBOutlet private weak var badgetView: UIView!
    @IBOutlet private weak var buttonImageView: UIImageView!
    
    var badgetNumber: Int = 0 {
        didSet {
            updateBadget(number: badgetNumber, animated: oldValue != badgetNumber)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override var isHighlighted: Bool {
        didSet {
            if oldValue != isHighlighted { updateAppearance() }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if oldValue != isEnabled { updateAppearance() }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if oldValue != isSelected { updateAppearance() }
        }
    }
}

private extension BadgedButton {
    func commonInit() {
        Bundle.main.loadNibNamed("BadgedButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.isUserInteractionEnabled = false
        contentView.frame = bounds
        badgetView.isHidden = true
        isEnabled = false
        badgetView.layer.cornerRadius = 8
    }
    
    func updateBadget(number: Int, animated: Bool) {
        guard number > 0 else {
            badgetView.isHidden = true
            isEnabled = false
            buttonImageView.image = UIImage(named: "plate")
            return
        }
        
        if animated {
            buttonImageView.image = UIImage(named: "plate.full")
            badgetView.isHidden = false
            badgetView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.badgetView.transform = .identity
            })
        }
        
        isEnabled = true
        badgetLabel.text = "\(number)"
    }
    
    func updateAppearance() {
        guard isEnabled else {
            contentView.alpha = 0.5
            return
        }
        if isSelected || isHighlighted {
            contentView.alpha = 0.7
        } else {
            contentView.alpha = 1
        }
    }
}
