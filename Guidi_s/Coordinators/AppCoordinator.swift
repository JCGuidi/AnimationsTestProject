//
//  AppCoordinator.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 16/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

//MARK: - CoordinatorProtocol Declaration

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get }
    func start()
    func childDidFinish(_ childCoordinator: CoordinatorProtocol)
}

//MARK: - MainCoordinator

final class AppCoordinator: NSObject, CoordinatorProtocol {

    private let router: Router
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        let onboardingCoordinator = OnboardingCoordinator(router: router, parentCoordinator: self)
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func startLogInFlow(animating: Bool = true) {
        let logInCoordinator = LogInCoordinator(router: router, parentCoordinator: self)
        childCoordinators.append(logInCoordinator)
        logInCoordinator.start(animating: animating)
    }
    
    func startMainFlow() {
        let mainViewCoordinator = MainViewCoordinator(router: router, parentCoordinator: self)
        childCoordinators.append(mainViewCoordinator)
        mainViewCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: CoordinatorProtocol) {
        if let index = childCoordinators.firstIndex(where: { (coordinator) -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
