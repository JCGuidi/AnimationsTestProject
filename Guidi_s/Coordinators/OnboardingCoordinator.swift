//
//  OnboardingCoordinator.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 24/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit
import MaskedTransitioning

final class OnboardingCoordinator: CoordinatorProtocol {
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private let parentCoordinator: AppCoordinator
    private let router: Router
    
    init(router: Router, parentCoordinator: AppCoordinator) {
        self.router = router
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let onboardingViewController: OnboardingViewController = .instantiate(from: AppConstants.onboardingStoryboard)
        let onboardingViewModel = OnboardingViewModel()
        onboardingViewModel.coordinator = self
        onboardingViewController.viewModel = onboardingViewModel
        router.set(onboardingViewController)
    }

    func startLogin() {
        parentCoordinator.childDidFinish(self)
        parentCoordinator.startLogInFlow(animating: false)
    }
    
    func childDidFinish(_ childCoordinator: CoordinatorProtocol) {
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
