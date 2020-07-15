//
//  FloatingTextField.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 14/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class FloatingTextField: UITextField {
    
    var floatingLabel: UILabel = UILabel(frame: CGRect.zero)
    var leftConstraint: NSLayoutConstraint?
    var centerConstraint: NSLayoutConstraint?
    let floatingLabelHeight: CGFloat = 14
    var placeholderString: String?
    
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.black
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
}

private extension FloatingTextField {
    
    func commonInit() {
        self.floatingLabel = UILabel(frame: CGRect.zero)
        borderStyle = .none
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        placeholderString = placeholder
        self.placeholder = ""
        addAuxiliaryLabel()
        
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: frame.height + 0.5, width: frame.width, height: 0.5)
        borderLayer.backgroundColor = (UIColor.lightGray.withAlphaComponent(0.5)).cgColor
        layer.addSublayer(borderLayer)
    }
    
    func addAuxiliaryLabel() {
        floatingLabel.frame = CGRect(x: 0,
                                     y: bounds.height / 2 - floatingLabelHeight / 2,
                                     width: bounds.width,
                                     height: floatingLabelHeight)
        floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        floatingLabel.font = font
        floatingLabel.clipsToBounds = true
        addSubview(self.floatingLabel)
        leftConstraint = floatingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0)
        centerConstraint = floatingLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        leftConstraint!.isActive = true
        centerConstraint!.isActive = true
        
        setPlaceholder()
    }
    
    func setPlaceholder() {
        floatingLabel.textColor = .lightGray
        floatingLabel.text = placeholderString
    }
    
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        guard (text ?? "").isEmpty else { return }
        
        floatingLabel.textColor = floatingLabelColor
        centerConstraint?.constant = -24
        leftConstraint?.constant = -5
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.layoutSubviews()
        }
    }
    
    @objc func removeFloatingLabel() {
        guard (text ?? "").isEmpty else { return }
        setPlaceholder()
        centerConstraint?.constant = 0
        leftConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.transform = .identity
            self.layoutSubviews()
        }
    }
}
