//
//  KeychainService.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService() // Делаем один доступ на всё приложение
    private init() {}

    // 1. СОХРАНИТЬ
    func save(password: String, for account: String) {
        let data = Data(password.utf8)
        let query: [String: Any] = [
                                   kSecClass as String: kSecClassGenericPassword,
                                   kSecAttrAccount as String: account,
                                   kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary) // Сначала удаляем старое, если было
        SecItemAdd(query as CFDictionary, nil) // Записываем новое
    }

    // 2. ДОСТАТЬ
    func getPassword(for account: String) -> String? {
        let query: [String: Any] = [
                                   kSecClass as String: kSecClassGenericPassword, kSecAttrAccount as String: account,
                                   kSecReturnData as String: kCFBooleanTrue!,
                                   kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
