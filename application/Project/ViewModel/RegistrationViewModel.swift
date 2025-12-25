//
//  RegistrationViewModel.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//

import Foundation

class RegistrationViewModel {
    private let content = RegistrationContent()
    private let authService = AuthService.shared
    
    var title: String { content.title }
    var emailPlaceholder: String { content.emailPlaceholder }
    var passwordPlaceholder: String { content.passwordPlaceholder }
    var buttonTitle: String { content.buttonTitle }
    
    var email = ""
    var password = ""
    var errorMessage: String?
    var isRegistering: Bool = false
    
    func register() -> Bool {
        if !AuthService.shared.isValidEmail(email) {
            errorMessage = content.invalidEmailError
            return false
        }
        
        if password.count < 6 {
            errorMessage = content.passwordTooShortError
            return false
        }
        
        let result = authService.register(email: email, password: password)
        
        switch result {
        case .success:
            errorMessage = nil
            isRegistering = true
        case .failure(let error):
            isRegistering = false
            if error == .userExists {
                errorMessage = content.userExistsError
            }
        }
        
        return isRegistering
    }
    

}
