//
//  AppSettingsService.swift
//  Project
//
//  Created by Даниил on 25.12.2025.
//

import Foundation

class AppSettingsService {
    static let shared = AppSettingsService()
    private let userDefaults = UserDefaults.standard
    private let darkModeKey = "isDarkMode"
    
    private init() {}
    
    var isDarkMode: Bool {
        get { userDefaults.bool(forKey: darkModeKey) }
        set { userDefaults.set(newValue, forKey: darkModeKey) }
    }
}
