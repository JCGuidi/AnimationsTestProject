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
    private let parentCoordinator: AppCoordinator
    
    init(router: Router, parentCoordinator: AppCoordinator) {
        self.router = router
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let mainViewController: MainViewController = .instantiate()
        let mainViewModel = MainViewModel(coordinator: self)
        mainViewController.viewModel = mainViewModel
        router.set(mainViewController, withAnimation: CircularTransitionToMain())
    }

    func presentChechout(over viewController: UIViewController) {
        let checkoutViewController: CheckoutViewController = .instantiate()
        let checkoutViewModel = CheckoutViewModel()
        checkoutViewModel.coordinator = self
        checkoutViewController.viewModel = checkoutViewModel
        router.present(checkoutViewController, over: viewController)
    }
    
    func presentDetail(for foodCategory: FoodCategory,
                       over viewController: UIViewController,
                       withAnimation animation: PresentDetailTransition,
                       interactor: TransitionInteractor = TransitionInteractor()) {
        let detailViewController: MenuDetailViewController = .instantiate()
        let detailViewModel = MenuDetailViewModel(coordinator: self, selectedFoodCategory: foodCategory, transition: animation, interactor: interactor)
        detailViewController.viewModel = detailViewModel
        animation.interactor = interactor
        self.animation = animation
        DispatchQueue.main.async {
            self.router.present(detailViewController, over: viewController, withAnimation: animation, interactor: interactor)
        }
    }
    
    func dismissDetail() {
        guard let animation = animation as? PresentDetailTransition else { return }
        animation.presenting = false
        router.dismiss()
    }
    
    func dismiss() {
        router.dismiss()
    }
    
    func restart() {
        router.dismiss()
        parentCoordinator.childDidFinish(self)
        parentCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: CoordinatorProtocol) {
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
