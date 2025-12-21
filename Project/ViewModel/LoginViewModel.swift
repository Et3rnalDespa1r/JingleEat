//
//  LoginViewModel.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//

import Foundation

class LoginViewModel {
    private let content = LoginContent()
    
    var title: String { content.title }
    var emailPlaceholder: String { content.emailPlaceholder }
    var passwordPlaceholder: String { content.passwordPlaceholder }
    var buttonTitle: String { content.buttonTitle }
    
    var email = ""
    var password = ""
    var errorMessage: String?
    
    func login() -> Bool {
        let userPassword = KeychainService.shared.getPassword(for: email)
        if userPassword == nil {
            errorMessage = content.userNotFound
            return false
        }
        if userPassword == password {
            errorMessage = nil
            return true
        } else {
            errorMessage = content.wrongPassword
            return false
        }
    }
}
