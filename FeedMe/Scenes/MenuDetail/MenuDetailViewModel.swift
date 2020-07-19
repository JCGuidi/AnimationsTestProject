//
//  MenuDetailViewModel.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 17/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

final class MenuDetailViewModel {
    private let coordinator: MainViewCoordinator
    private(set) var foodToDisplay: [DetailCellViewModel] = []
    let transition: PresentDetailTransition?
    let interactor: TransitionInteractor?
    
    let title: String!
    let selectedFoodCategory: FoodCategory!
    
    func handleDismissTap() {
        coordinator.dismissDetail()
    }
    
    init(coordinator: MainViewCoordinator,
         selectedFoodCategory: FoodCategory,
         transition: PresentDetailTransition,
         interactor: TransitionInteractor,
         cart: Cart = Cart.shared) {
        
        self.coordinator = coordinator
        self.transition = transition
        self.interactor = interactor
        self.selectedFoodCategory = selectedFoodCategory
        
        title = selectedFoodCategory.title
        
        selectedFoodCategory.food.forEach { (plate) in
            foodToDisplay.append(DetailCellViewModel(name: plate.name,
                                                     imageName: plate.imageName,
                                                     ingredients: plate.ingredients,
                                                     isOnCart: cart.orders.contains(plate.name),
                                                     addActionHandler: { cart.add(newOrder: plate.name) },
                                                     removeActionHandler: { cart.remove(order: plate.name)}))
        }
    }
}
