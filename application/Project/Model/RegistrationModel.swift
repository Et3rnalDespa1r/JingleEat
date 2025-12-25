//
//  Registration.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//

import Foundation

struct RegistrationContent {
    let title = "Создать аккаунт"
    let emailPlaceholder = "Ваш Email"
    let passwordPlaceholder = "Пароль (мин. 6 знаков)"
    let buttonTitle = "Зарегистрироваться"
    
    let invalidEmailError = "Некорректный формат почты"
    let passwordTooShortError = "Пароль должен быть от 6 символов"
    let userExistsError = "Пользователь с этим email уже зарегистрирован"
}
