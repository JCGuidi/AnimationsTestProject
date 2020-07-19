//
//  FoodTypeTableViewCell.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 16/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class FoodTypeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet private weak var titleBackgroundView: UIVisualEffectView!
    @IBOutlet private weak var cellTitle: UILabel!
    
    private enum Constants {
        static let maxCornerRadius: CGFloat = 12
        static let minCornerRadius: CGFloat = 6
    }
    
    private (set) var viewModel: FoodCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleImageView.layer.cornerRadius = Constants.maxCornerRadius
        setUpTitleBackground()
        backgroundColor = .clear
    }
    
    func set(viewModel: FoodCellViewModel) {
        cellTitle.text = viewModel.title
        titleImageView.image = UIImage(named: viewModel.imageName)
        self.viewModel = viewModel
    }
}
 
//MARK: - Private Methods

private extension FoodTypeTableViewCell {
    func setUpTitleBackground() {
        titleBackgroundView.layer.cornerRadius = Constants.minCornerRadius
        titleBackgroundView.clipsToBounds = true
        titleBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner]
        
        let maskPath = UIBezierPath(roundedRect: titleBackgroundView.bounds,
                                    byRoundingCorners: [.bottomRight],
                                    cornerRadii: CGSize(width: Constants.maxCornerRadius, height: 0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        titleBackgroundView.layer.mask = maskLayer
    }
}
