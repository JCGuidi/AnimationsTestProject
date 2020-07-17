//
//  DetailTableViewCell.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 16/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var innerView: UIView!
    @IBOutlet private weak var foodImageView: UIImageView!
    @IBOutlet private weak var foodTitle: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var foodIngredients: UILabel!
    
    var viewModel: DetailCellViewModel?
    var shouldAdd = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.layer.cornerRadius = 12
        foodImageView.layer.cornerRadius = 4
    }
    
    func configure(with viewModel: DetailCellViewModel) {
        self.viewModel = viewModel
        foodTitle.text = viewModel.name
        foodImageView.image = UIImage(named: viewModel.imageName)
        guard !viewModel.ingredients.isEmpty else {
            ingredientsLabel.isHidden = true
            foodIngredients.isHidden = true
            return
        }
        foodIngredients.text = viewModel.ingredients
    }
    
    @IBAction func addButtonTapped(_ sender: AddRemoveButton) {
        if shouldAdd {
            sender.setTitle("Remove", for: .normal)
            viewModel?.addActionHandler?()
        } else {
            sender.setTitle("Add", for: .normal)
            viewModel?.addActionHandler?()
        }
        shouldAdd.toggle()
    }
}
