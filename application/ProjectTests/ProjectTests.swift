//
//  ProjectTests.swift
//  ProjectTests
//
//  Created by Даниил on 24.12.2025.
//

import XCTest
@testable import Project

@MainActor
final class ProjectTests: XCTestCase {
    
    // MARK: - 1. Тесты Модели Recipe
    
    func testRecipeDecoding() throws {
        let json = """
        {
            "id": "123",
            "description": "Вкусный тест",
            "videoUrl": "http://video.com/1.mp4",
            "createdDate": 1703400000,
            "isLiked": true
        }
        """.data(using: .utf8)!
        
        let recipe = try JSONDecoder().decode(Recipe.self, from: json)
        
        XCTAssertEqual(recipe.id, "123")
        XCTAssertEqual(recipe.description, "Вкусный тест")
        XCTAssertEqual(recipe.videoUrl, "http://video.com/1.mp4")
        XCTAssertTrue(recipe.isLiked)
    }
    
    func testRecipeSmartURL() {
        let remoteRecipe = Recipe(id: "1", description: "Remote", videoUrl: "http://test.com/video.mp4", coverUrl: nil, createdDate: 0)
        XCTAssertEqual(remoteRecipe.smartURL?.absoluteString, "http://test.com/video.mp4")
        
        let localRecipe = Recipe(id: "2", description: "Local", videoUrl: "my_video.mp4", coverUrl: nil, createdDate: 0)
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let expectedURL = docURL.appendingPathComponent("my_video.mp4")
        XCTAssertEqual(localRecipe.smartURL?.path, expectedURL.path)
    }
    
    // MARK: - 2. Тесты RegistrationViewModel (Валидация)
    
    func testEmailValidation() {
        let service = AuthService.shared
        
        XCTAssertTrue(service.isValidEmail("test@mail.ru"))
        XCTAssertTrue(service.isValidEmail("user.name@domain.com"))
        XCTAssertFalse(service.isValidEmail("invalid"))
        XCTAssertFalse(service.isValidEmail("@domain.com"))
    }
    
    func testRegistrationLogicTooShortPassword() {
        let service = AuthService.shared
        let email = "valid@email.com"
        let password = "123"
        let result = service.register(email:email, password:password)
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .passwordTooShort)
        case .success:
            XCTFail("Должна быть ошибка длины пароля")
        }
    }

    // MARK: - 3. Тесты RecipeService (RAG Logic)
    
    func testRecipeServiceContext() {
        let service = RecipeService.shared
        let context = service.findContext(for: "оливье")
        
        XCTAssertTrue(context.lowercased().contains("оливье") || context.contains("В меню есть:"))
    }
    
    func testChatRAGContextNotFound() {
        let context = RecipeService.shared.findContext(for: "синхрофазотрон")
        XCTAssertTrue(context.contains("В меню есть:"), "Должен возвращаться дефолтный список")
    }
    
    // MARK: - 4. Тесты Login / Auth Logic
    
    func testLoginViewModelInit() {
        let service = AuthService.shared
        let result = service.login(email: "", password: "")
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .userNotFound)
        case .success:
            XCTFail("Должна быть ошибка длины пароля")
        }
    }
    
    func testAuthServiceLoginUserNotFound() {
        let result = AuthService.shared.login(email: "nonexistent@test.com", password: "123")
        
        if case .failure(let error) = result {
            XCTAssertEqual(error, .userNotFound)
        } else {
            XCTFail("Должна быть ошибка: пользователь не найден")
        }
    }
    
    // MARK: - 5. Тесты Слоя Данных (StorageService)
    
    func testStorageServiceLikeLogic() {
        let service = StorageService.shared
        let initialCount = service.loadRecipes().count
        
        service.addNewVideo(filename: "test_video.mp4", description: "Test Desc")
        let newCount = service.loadRecipes().count
        XCTAssertEqual(newCount, initialCount + 1)
        
        if let addedRecipe = service.loadRecipes().last {
            let wasLiked = addedRecipe.isLiked
            service.toggleLike(for: addedRecipe)
            
            let updatedRecipe = service.loadRecipes().first { $0.id == addedRecipe.id }
            XCTAssertNotEqual(updatedRecipe?.isLiked, wasLiked)
            
            service.deleteRecipe(id: addedRecipe.id)
        }
    }
    
    // MARK: - 6. Тесты Settings / AppSettingsService
    
    func testSettingsDarkMode() {
        let service = AppSettingsService.shared
        let initialMode = service.isDarkMode
        
        service.isDarkMode.toggle()
        XCTAssertNotEqual(service.isDarkMode, initialMode)
        
        let savedMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        XCTAssertEqual(savedMode, service.isDarkMode)
        
        // Возвращаем обратно
        service.isDarkMode = initialMode
    }
    
    // MARK: - 7. Тесты Моделей GigaChat
    
    func testGigaChatResponseDecoding() throws {
        let json = "{\"choices\": [{\"message\": {\"role\": \"assistant\", \"content\": \"Hi\"}}]}".data(using: .utf8)!
        let response = try JSONDecoder().decode(GigaChatResponse.self, from: json)
        XCTAssertEqual(response.choices.first?.message.content, "Hi")
    }

    // MARK: - 8. Тесты HomeViewModel (Видео Логика)
    
    func testHomeViewModelInit() {
        let service = StorageService.shared
        let recipes = service.loadRecipes()
        XCTAssertFalse(recipes.isEmpty, "Сервис должен вернуть список рецептов")
    }
    
    func testVideoServiceURLTransformation() {
        let recipe = Recipe(id: "test", description: "Desc", videoUrl: "https://www.dropbox.com/s/123/video.mp4", coverUrl: nil, createdDate: 0)
        let transformedURL = VideoService.shared.getAppropriateURL(for: recipe)
        
        XCTAssertTrue(transformedURL?.absoluteString.contains("dl.dropboxusercontent.com") ?? false, "Dropbox URL должен преобразовываться в прямую ссылку")
    }
}
