//
//  LoginViewModel.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//

import Foundation

class LoginViewModel {
    private let content = LoginContent()
    private let authService = AuthService.shared
    
    var title: String { content.title }
    var emailPlaceholder: String { content.emailPlaceholder }
    var passwordPlaceholder: String { content.passwordPlaceholder }
    var buttonTitle: String { content.buttonTitle }
    
    var email = ""
    var password = ""
    var errorMessage: String?
    var isLogin = false
    
    func login() -> Bool {
        let result = authService.login(email: email, password: password)
        
        switch result {
        case .success:
            errorMessage = nil
            isLogin = true
        case .failure(let error):
            isLogin = false
            switch error {
            case .userNotFound:
                errorMessage = content.userNotFound
            case .wrongPassword:
                errorMessage = content.wrongPassword
            case .userExists:
                errorMessage = "Этот аккаунт уже существует"
            case .passwordTooShort:
                errorMessage = "Слишком короткий пароль"
            case .invalidEmail:
                errorMessage = "Неправильный адрес электронной почты"
            }
        }
        return isLogin
    }
}
