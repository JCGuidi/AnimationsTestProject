//
//  MainViewCoordinator.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class MainViewCoordinator: CoordinatorProtocol {
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private let router: Router
    private var animation: UIViewControllerAnimatedTransitioning!
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        let mainViewController: MainViewController = .instantiate()
        let mainViewModel = MainViewModel()
        mainViewModel.coordinator = self
        mainViewController.viewModel = mainViewModel
        router.set(mainViewController, withAnimation: CircularTransitionToMain())
    }

    func presentDetail(for foodCategory: FoodCategory,
                       over viewController: UIViewController,
                       withAnimation animation: UIViewControllerAnimatedTransitioning) {
        let detailViewController: MenuDetailViewController = .instantiate()
        let detailViewModel = MenuDetailViewModel(selectedFoodCategory: foodCategory)
        detailViewModel.coordinator = self
        detailViewController.viewModel = detailViewModel
        self.animation = animation
        DispatchQueue.main.async {
            self.router.present(detailViewController, over: viewController, withAnimation: animation)
        }
    }
    
    func dismissDetail() {
        guard let animation  = animation as? PresentDetailTransition else { return }
        animation.presenting = false
        router.dismiss()
    }
    
    func childDidFinish(_ childCoordinator: CoordinatorProtocol) {
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
