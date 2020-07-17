//
//  LogInViewModel.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

final class LogInViewModel {
    var coordinator: LogInCoordinator?
    var onLogInSuccess: (()->Void)? = nil
    
    func logIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.onLogInSuccess?()
            self.coordinator?.startMain()
        }
    }
}
