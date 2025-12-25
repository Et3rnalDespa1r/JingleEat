import Foundation
import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var currentScrollID: String?
    private var currentDownloadTask: Task<Void, Never>?
    
    private let storage: StorageService
        
    init(storage: StorageService = .shared) {
        self.storage = storage
        self.recipes = storage.loadRecipes()
    }

    func handleScrollChange(newID: String?) {
        self.currentScrollID = newID
        VideoPlayerManager.shared.pauseVideo()
        currentDownloadTask?.cancel()
        
        guard let newID = newID,
              let recipe = recipes.first(where: { $0.id == newID }) else { return }
        
        currentDownloadTask = Task {
            guard let url = VideoService.shared.getAppropriateURL(for: recipe) else { return }
            
            if !Task.isCancelled && currentScrollID == newID {
                VideoPlayerManager.shared.playVideo(at: url)
            }
            
            if !url.isFileURL {
                Task.detached(priority: .background) {
                    try? await VideoLoader.shared.downloadVideo(from: recipe.videoUrl)
                }
            }
        }
    }
}
