//
//  AppCoordinator.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get }
    func start()
    func childDidFinish(_ childCoordinator: CoordinatorProtocol)
}

final class AppCoordinator: NSObject, CoordinatorProtocol {

    private let router: Router
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        startMainFlow()
//        let logInCoordinator = LogInCoordinator(router: router, parentCoordinator: self)
//        childCoordinators.append(logInCoordinator)
//        logInCoordinator.start()
    }
    
    func startMainFlow() {
        let mainViewCoordinator = MainViewCoordinator(router: router)
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
