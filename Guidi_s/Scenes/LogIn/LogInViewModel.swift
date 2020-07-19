//
//  LogInViewModel.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 15/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

final class LogInViewModel {
    var coordinator: LogInCoordinator?
    var onLogInSuccess: (() -> Void)? = nil
    var onValidInputs: ((Bool) -> Void)? = nil
    
    var validInputs: Bool = false {
        didSet { onValidInputs?(validInputs) }
    }
    
    func logIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.onLogInSuccess?()
            self.coordinator?.startMain()
        }
    }
    
    func validate(username: String, password: String) {
        validInputs = !username.isEmpty && !password.isEmpty
    }
}
