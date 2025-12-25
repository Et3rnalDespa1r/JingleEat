//
//  SettingsViewModel.swift
//  Project
//
//  Created by Даниил on 24.12.2025.
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            AppSettingsService.shared.isDarkMode = isDarkMode
        }
    }
    
    init() {
        self.isDarkMode = AppSettingsService.shared.isDarkMode
    }
    
    func clearUserData() {
        AuthService.shared.logout()
    }
}
