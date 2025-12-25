//
//  SettingsView.swift
//  Project
//
//  Created by Даниил on 24.12.2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var contentColor: Color {
        colorScheme == .dark ? .white : Color(red: 0.35, green: 0.18, blue: 0.05)
    }
    
    var cardBackgroundColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.4) : Color.white.opacity(0.85)
    }
    
    var body: some View {
        ZStack {
            ChristmasBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(contentColor)
                            .padding(12)
                            .background(cardBackgroundColor)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Настройки")
                        .font(.title2)
                        .bold()
                        .foregroundColor(contentColor)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    HStack {
                        Image(systemName: viewModel.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.system(size: 22))
                            .foregroundColor(contentColor)
                            .frame(width: 30)
                        
                        Text("Ночная тема")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(contentColor)
                        
                        Spacer()
                        
                        Toggle("", isOn: $viewModel.isDarkMode)
                            .labelsHidden()
                            .tint(contentColor)
                    }
                    .padding()
                    .background(cardBackgroundColor)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Кнопка выхода
                    Button(action: {
                        performLogout()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Выйти")
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.red.opacity(0.85)) // Красный оставляем как есть, он заметный
                        .cornerRadius(16)
                        .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onChange(of: viewModel.isDarkMode) { newValue in
            updateAppTheme(isDark: newValue)
        }
        .onAppear {
            updateAppTheme(isDark: viewModel.isDarkMode)
        }
    }
    
    private func updateAppTheme(isDark: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }, completion: nil)
    }
    
    private func performLogout() {
        viewModel.clearUserData()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        let loginVC = ViewController()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
            window.rootViewController = loginVC
        }, completion: nil)
    }
}
