//
//  LogInCoordinator.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit
import MaskedTransitioning

final class LogInCoordinator: CoordinatorProtocol {
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private let parentCoordinator: AppCoordinator
    private let router: Router
    
    init(router: Router, parentCoordinator: AppCoordinator) {
        self.router = router
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        start(animating: true)
    }
    
    func start(animating: Bool) {
        let logInViewController: LogInViewController = .instantiate()
        let logInViewModel = LogInViewModel()
        logInViewModel.coordinator = self
        logInViewModel.animated = animating
        logInViewController.viewModel = logInViewModel
        
        if animating {
            router.set(logInViewController)
        } else {
            let transition = TabBarMaskedTransition()
            router.set(logInViewController, withAnimation: transition)
        }
        
    }

    func startMain() {
        parentCoordinator.childDidFinish(self)
        parentCoordinator.startMainFlow()
    }
    
    func childDidFinish(_ childCoordinator: CoordinatorProtocol) {
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
