//
//  AuthService.swift
//  Project
//
//  Created by Даниил on 25.12.2025.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    private let keychain = KeychainService.shared
    
    private init() {}
    
    func login(email: String, password: String) -> Result<Void, AuthError> {
        guard let savedPassword = keychain.getPassword(for: email) else {
            return .failure(.userNotFound)
        }
        return savedPassword == password ? .success(()) : .failure(.wrongPassword)
    }
    
    func register(email: String, password: String) -> Result<Void, AuthError> {
        if !isValidEmail(email) {
            return .failure(.invalidEmail)
        }
        
        if password.count < 6 {
            return .failure(.passwordTooShort)
        }
        
        if keychain.getPassword(for: email) != nil {
            return .failure(.userExists)
        }
        
        keychain.save(password: password, for: email)
        return .success(())
    }
    
    func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    func logout() {
            keychain.setLoggedIn(false)
            print("Пользователь вышел из системы")
    }
}

enum AuthError: Error, Equatable {
    case userNotFound
    case wrongPassword
    case userExists
    case invalidEmail
    case passwordTooShort
}
