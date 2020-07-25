//
//  OnboardingViewModel.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 25/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

final class OnboardingViewModel {
    var coordinator: OnboardingCoordinator?
    
    func handleSkipTap() {
        startLogin()
    }
    
    func handleReadyTap() {
        startLogin()
    }
    
    private func startLogin() {
        coordinator?.startLogin()
    }
}
