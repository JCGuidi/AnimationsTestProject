//
//  MenuDetailViewModel.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 16/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

final class MenuDetailViewModel {
    private(set) var foodToDisplay: [DetailCellViewModel] = []
    let title: String!
    let selectedFoodCategory: FoodCategory!
    var coordinator: MainViewCoordinator?
    
    func handleDismissTap() {
        coordinator?.dismissDetail()
    }
    
    init(selectedFoodCategory: FoodCategory, cart: Cart = Cart.shared) {
        self.selectedFoodCategory = selectedFoodCategory
        title = selectedFoodCategory.title
        selectedFoodCategory.food.forEach { (plate) in
            foodToDisplay.append(DetailCellViewModel(name: plate.name,
                                                     imageName: plate.imageName,
                                                     ingredients: plate.ingredients,
                                                     addActionHandler: { cart.add(newOrder: plate.name) },
                                                     removeActionHandler: { cart.remove(order: plate.name)}))
        }
    }
}
