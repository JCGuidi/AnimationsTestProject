//
//  OnboardingViewController.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 24/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit
import AlphaTransitioning

final class OnboardingViewController: AlphaTransitioningTabBarViewController {
    
    var viewModel: OnboardingViewModel!
    
    func skipTap() {
        viewModel.handleSkipTap()
    }
    
    func finishTap() {
        viewModel.handleReadyTap()
    }
}
