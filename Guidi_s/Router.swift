//
//  Router.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 16/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class Router: NSObject {
    private let navigationController: UINavigationController
    private var transition: UIViewControllerAnimatedTransitioning?
    private var interactor: TransitionInteractor?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.navigationBar.isHidden = true
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
                 presentationStyle: UIModalPresentationStyle = .fullScreen,
                 withAnimation animation: UIViewControllerAnimatedTransitioning? = nil,
                 interactor: TransitionInteractor? = nil) {
        self.interactor = interactor
        transition = animation
        viewController.modalPresentationStyle = presentationStyle
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
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactor = interactor, interactor.hasStarted else { return nil }
        return interactor
    }
    
    
}
