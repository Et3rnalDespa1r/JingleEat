//
//  ChatMessage.swift
//  Project
//
//  Created by Даниил on 25.12.2025.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}
