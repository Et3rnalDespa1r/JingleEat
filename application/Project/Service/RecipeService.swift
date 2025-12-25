//
//  RecipeService.swift
//  Project
//
//  Created by Даниил on 25.12.2025.
//

import Foundation

class RecipeService {
    static let shared = RecipeService()
    private var recipes: [[String: String]] = []

    private init() {
        loadJSON()
    }

    private func loadJSON() {
        let bundle = Bundle(for: RecipeService.self)
        guard let path = bundle.path(forResource: "recipesForGigaChat", ofType: "json") else {
            print("RecipeService: JSON не найден")
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            recipes = try JSONSerialization.jsonObject(with: data) as? [[String: String]] ?? []
        } catch {
            print("RecipeService Error: \(error)")
        }
    }

    func findContext(for query: String) -> String {
        let queryWords = query.lowercased().split(separator: " ")
        
        if recipes.isEmpty {
            return "В меню есть: салаты (Оливье, свекла, булгур), утка, телятина, десерты (морковный торт, печенье)."
        }

        let matches = recipes.filter { recipe in
            let title = recipe["title"]?.lowercased() ?? ""
            let desc = recipe["description"]?.lowercased() ?? ""
            return queryWords.contains { title.contains($0) || desc.contains($0) }
        }

        if matches.isEmpty {
            return "В меню есть: салаты (Оливье, свекла, булгур), утка, телятина, десерты (морковный торт, печенье)."
        }

        return matches.compactMap {
            guard let title = $0["title"], let desc = $0["description"] else { return nil }
            return "Блюдо: \(title). Описание: \(desc)"
        }.joined(separator: "\n")
    }
}
