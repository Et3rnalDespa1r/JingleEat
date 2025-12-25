//
//  GigaChat.swift
//  Project
//
//  Created by Даниил on 24.12.2025.
//

struct GigaChatMessage: Codable {
    let role: String
    let content: String
}

struct GigaChatRequest: Codable {
    let model: String
    let messages: [GigaChatMessage]
    let temperature: Double
}

struct GigaChatResponse: Codable {
    let choices: [GigaChatChoice]
}

struct GigaChatChoice: Codable {
    let message: GigaChatMessage
}

struct TokenResponse: Codable {
    let access_token: String
    let expires_at: Int
}
