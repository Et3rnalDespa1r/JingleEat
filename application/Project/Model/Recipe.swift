//
//  Recipe.swift
//  Project
//
//  Created by Даниил on 21.12.2025.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: String
    let description: String
    let videoUrl: String
    let coverUrl: String?
    let createdDate: TimeInterval
    
    var isLiked: Bool = false
    var isSaved: Bool = false
    var isMyVideo: Bool = false
    
    var userName: String {
        return "JingleEat"
    }
    
    var smartURL: URL? {
        if videoUrl.lowercased().hasPrefix("http") {
            return URL(string: videoUrl)
        } else {
            let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return docUrl.appendingPathComponent(videoUrl)
        }
    }
    
    var localFileURL: URL? {
        if !videoUrl.hasPrefix("http") {
            return smartURL
        }
        return VideoLoader.shared.getCachedPath(for: videoUrl)
    }
    
    var isDownloaded: Bool {
        return localFileURL != nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, description, videoUrl, coverUrl, createdDate
        case isLiked, isSaved, isMyVideo
    }
    
    init(id: String, description: String, videoUrl: String, coverUrl: String?, createdDate: TimeInterval) {
        self.id = id
        self.description = description
        self.videoUrl = videoUrl
        self.coverUrl = coverUrl
        self.createdDate = createdDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        videoUrl = try container.decode(String.self, forKey: .videoUrl)
        coverUrl = try container.decodeIfPresent(String.self, forKey: .coverUrl)
        createdDate = try container.decode(TimeInterval.self, forKey: .createdDate)
        
        isLiked = try container.decodeIfPresent(Bool.self, forKey: .isLiked) ?? false
        isSaved = try container.decodeIfPresent(Bool.self, forKey: .isSaved) ?? false
        isMyVideo = try container.decodeIfPresent(Bool.self, forKey: .isMyVideo) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(description, forKey: .description)
        try container.encode(videoUrl, forKey: .videoUrl)
        try container.encode(coverUrl, forKey: .coverUrl)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(isLiked, forKey: .isLiked)
        try container.encode(isSaved, forKey: .isSaved)
        try container.encode(isMyVideo, forKey: .isMyVideo)
    }
}
