//
//  RegistrationViewModel.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//

import Foundation

class RegistrationViewModel {
    private let content = RegistrationContent()
    
    var title: String { content.title }
    var emailPlaceholder: String { content.emailPlaceholder }
    var passwordPlaceholder: String { content.passwordPlaceholder }
    var buttonTitle: String { content.buttonTitle }
    
    var email = ""
    var password = ""
    var errorMessage: String?
    
    func validateAndRegister() -> Bool {
        if !isValidEmail(email) {
            errorMessage = content.invalidEmailError
            return false
        }
        
        if password.count < 6 {
            errorMessage = content.passwordTooShortError
            return false
        }
        let userPassword = KeychainService.shared.getPassword(for: email)
        if userPassword != nil {
            errorMessage = content.userExistsError
            return false
        }
        KeychainService.shared.save(password: password, for: email)
        errorMessage = nil
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
