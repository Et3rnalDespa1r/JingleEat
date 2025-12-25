//
//  VideoService.swift
//  Project
//
//  Created by Даниил on 25.12.2025.
//
import Foundation

class VideoService {
    static let shared = VideoService()
    
    func getAppropriateURL(for recipe: Recipe) -> URL? {
        guard let videoURL = recipe.smartURL else { return nil }
        
        if videoURL.isFileURL { return videoURL }
        
        if let localCached = VideoLoader.shared.getCachedPath(for: recipe.videoUrl) {
            return localCached
        }
        
        let streamUrlString = recipe.videoUrl.replacingOccurrences(of: "www.dropbox.com", with: "dl.dropboxusercontent.com")
        return URL(string: streamUrlString)
    }
}
