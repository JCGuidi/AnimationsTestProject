//
//  Router.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class Router: NSObject {
    private let navigationController: UINavigationController
    private var transition: UIViewControllerAnimatedTransitioning?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
    }
    
    func set(_ viewController: UIViewController) {
        transition = nil
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func set(_ viewController: UIViewController, withAnimation animation: UIViewControllerAnimatedTransitioning) {
        transition = animation
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func present(_ viewController: UIViewController,
                 over presenter: UIViewController,
                 withAnimation animation: UIViewControllerAnimatedTransitioning? = nil) {
        transition = animation
        viewController.modalPresentationStyle = .fullScreen
        viewController.transitioningDelegate = self
        presenter.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        navigationController.viewControllers.last?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension Router: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}
