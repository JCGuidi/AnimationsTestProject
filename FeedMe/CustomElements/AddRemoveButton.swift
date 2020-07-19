//
//  AddRemoveButton.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 18/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class AddRemoveButton: UIButton {
    private var newTitleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        newTitleLabel = getNewLabel()
        addSubview(newTitleLabel!)
        super.setTitle("", for: state)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        newTitleLabel = getNewLabel()
        addSubview(newTitleLabel!)
        super.setTitle("", for: state)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else { return }
        animateTo(newTitle: title)
    }
}

private extension AddRemoveButton {
    func getNewLabel() -> UILabel {
        let label = UILabel(frame: bounds)
        label.font = titleLabel?.font
        label.textColor = titleLabel?.textColor
        label.text = titleLabel?.text
        label.textAlignment = .center
        return label
    }
    
    func animateTo(newTitle: String) {
        let auxLabel = getNewLabel()
        auxLabel.text = newTitle
        addSubview(auxLabel)
        let auxLabelOffset = auxLabel.frame.size.width/2.0
        auxLabel.transform = CGAffineTransform(translationX: auxLabelOffset, y: 0).scaledBy(x: 0.1, y: 1)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        auxLabel.transform = .identity
                        self.newTitleLabel?.transform = CGAffineTransform(translationX: -auxLabelOffset, y: 0).scaledBy(x: 0.1, y: 1)
                        self.newTitleLabel?.alpha = 0
        },
                       completion: { _ in
                        self.newTitleLabel?.text = auxLabel.text
                        self.newTitleLabel?.transform = .identity
                        self.newTitleLabel?.alpha = 1
                        auxLabel.removeFromSuperview()
        })
    }
}
