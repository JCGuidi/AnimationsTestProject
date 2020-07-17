//
//  MainViewModel.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class MainViewModel {
    
    static let pizzas = [
        Food(name: "Pizza Pepperoni", imageName: "pizza1", ingredients: "Mozzarella,\nPepperoni"),
        Food(name: "Pizza Crudo e Rucola", imageName: "pizza2", ingredients: "Mozzarella,\nProsciutto,\nArugula"),
        Food(name: "Pizza Margherita", imageName: "pizza3", ingredients: "Mozzarella,\nBasil"),
        Food(name: "Pizza Provolone", imageName: "pizza4", ingredients: "Mozzarella,\nProvolone,\nTomato"),
        Food(name: "Pizza Diavolo", imageName: "pizza5", ingredients: "Mozzarella,\nTabasco sauce,\nChilli pepper"),
        Food(name: "Pizza Burrata", imageName: "pizza6", ingredients: "Mozzarella,\nArugula,\nCream Cheese")
    ]
    
    static let pastas = [
        Food(name: "Spaghetti alla Carbonara", imageName: "pasta1"),
        Food(name: "Tagliatelle al Ragu", imageName: "pasta2"),
        Food(name: "Farfalle al Pesto", imageName: "pasta3")
    ]
    
    static let gelatos = [
        Food(name: "Nocciola", imageName: "gelato1"),
        Food(name: "Fragola", imageName: "gelato2"),
        Food(name: "Vaniglia", imageName: "gelato3")
    ]
    
    static let categories = [
        FoodCategory(title: "Pizza", imageName: "pizza0", food: pizzas),
        FoodCategory(title: "Pasta", imageName: "pasta0", food: pastas),
        FoodCategory(title: "Gelato", imageName: "gelato0", food: gelatos)
    ]
    
    private(set) var foodToDisplay: [FoodCellViewModel] = []
    let cart: Cart
    var coordinator: MainViewCoordinator?
    
    init(cart: Cart = .shared) {
        self.cart = cart
        MainViewModel.categories.forEach { (category) in
            foodToDisplay.append(FoodCellViewModel(title: category.title, imageName: category.imageName))
        }
    }
    
    func handleRowTapFor(cell: FoodTypeTableViewCell, on viewController: UIViewController, withImageFrame frame: CGRect) {
        guard
            let information = cell.viewModel,
            let foodCategory = MainViewModel.categories.first(where: { $0.title == information.title })
            else { return }
        
        let transition = PresentDetailTransition()
        transition.originFrame = frame
        
        coordinator?.presentDetail(for: foodCategory, over: viewController, withAnimation: transition)
    }
}
