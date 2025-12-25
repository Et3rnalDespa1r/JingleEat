//
//  StorageService.swift
//  Project
//
//  Created by Даниил on 23.12.2025.
//

import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let fileName = "recipes.json"
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var documentsFileURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }
    
    func loadRecipes() -> [Recipe] {
        if !FileManager.default.fileExists(atPath: documentsFileURL.path) {
            copyInitialData()
        }
        
        do {
            let data = try Data(contentsOf: documentsFileURL)
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            return recipes
        } catch {
            return []
        }
    }
    
    private func saveRecipes(_ recipes: [Recipe]) {
        do {
            let data = try JSONEncoder().encode(recipes)
            try data.write(to: documentsFileURL)
            NotificationCenter.default.post(name: NSNotification.Name("RecipesUpdated"), object: nil)
        } catch {
            print(error)
        }
    }
    
    func addNewVideo(filename: String, description: String) {
        var currentRecipes = loadRecipes()
        
        var newRecipe = Recipe(
            id: UUID().uuidString,
            description: description,
            videoUrl: filename,
            coverUrl: nil,
            createdDate: Date().timeIntervalSince1970
        )
        newRecipe.isMyVideo = true
        
        currentRecipes.append(newRecipe)
        saveRecipes(currentRecipes)
    }
    
    func toggleLike(for recipe: Recipe) {
        var currentRecipes = loadRecipes()
        if let index = currentRecipes.firstIndex(where: { $0.id == recipe.id }) {
            currentRecipes[index].isLiked.toggle()
            saveRecipes(currentRecipes)
        }
    }
    
    func toggleSave(for recipe: Recipe) {
        var currentRecipes = loadRecipes()
        if let index = currentRecipes.firstIndex(where: { $0.id == recipe.id }) {
            currentRecipes[index].isSaved.toggle()
            saveRecipes(currentRecipes)
        }
    }
    
    func saveVideoToDocuments(from sourceUrl: URL) -> String? {
        let fileName = UUID().uuidString + ".mp4"
        let destinationUrl = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                try FileManager.default.removeItem(at: destinationUrl)
            }
            try FileManager.default.copyItem(at: sourceUrl, to: destinationUrl)
            return fileName
        } catch {
            return nil
        }
    }
    
    func deleteRecipe(id: String) {
        var currentRecipes = loadRecipes()
        currentRecipes.removeAll { $0.id == id }
        saveRecipes(currentRecipes)
    }
    
    private func copyInitialData() {
        guard let bundleURL = Bundle.main.url(forResource: "recipes", withExtension: "json") else { return }
        try? FileManager.default.copyItem(at: bundleURL, to: documentsFileURL)
    }
}
