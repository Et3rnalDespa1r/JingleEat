//
//  ChatViewModel.swift
//  Project
//
//  Created by Даниил on 24.12.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(text: "Привет! Я новогодний шеф JingleEat 🎄. Подберу идеальные рецепты из нашего меню 2026. О чем рассказать?", isUser: false)
    ]
    @Published var isLoading = false
    @Published var inputText = ""

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        messages.append(ChatMessage(text: text, isUser: true))
        inputText = ""
        isLoading = true

        // Теперь просто просим сервис найти контекст
        let context = RecipeService.shared.findContext(for: text)

        let prompt = """
        Ты — новогодний шеф-повар. Отвечай по делу. Используй список:
        \(context)
        Вопрос: "\(text)"
        """

        Task {
            do {
                let response = try await GigaChatService.shared.sendMessage(prompt: prompt)
                messages.append(ChatMessage(text: response, isUser: false))
            } catch {
                messages.append(ChatMessage(text: "Ошибка кухни ❄️", isUser: false))
            }
            isLoading = false
        }
    }
}
