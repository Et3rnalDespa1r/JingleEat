import Foundation

class VideoLoader {
    static let shared = VideoLoader()
    private let fileManager = FileManager.default
    
    private var cacheDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    private func getFileName(for urlString: String) -> String {
        guard let data = urlString.data(using: .utf8) else { return "temp_video.mp4" }
        let base64 = data.base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "=", with: "")
        let result = String(base64.suffix(50))
        return result + ".mp4"
    }

    func getCachedPath(for urlString: String) -> URL? {
        let filename = getFileName(for: urlString)
        guard let cacheDir = cacheDirectory else { return nil }
        let fileUrl = cacheDir.appendingPathComponent(filename)
        
        if fileManager.fileExists(atPath: fileUrl.path) {
            return fileUrl
        }
        return nil
    }

    func downloadVideo(from urlString: String) async throws -> URL {
        if let localUrl = getCachedPath(for: urlString) {
            print("📦 Файл найден в кэше: \(localUrl.path)")
            return localUrl
        }

        print("⬇️ Скачиваем: \(urlString)")
        let cleanUrl = urlString.replacingOccurrences(of: "www.dropbox.com", with: "dl.dropboxusercontent.com")
        
        guard let downloadUrl = URL(string: cleanUrl) else {
            throw URLError(.badURL)
        }

        let (tempUrl, _) = try await URLSession.shared.download(from: downloadUrl)
        
        let filename = getFileName(for: urlString)
        guard let saveUrl = cacheDirectory?.appendingPathComponent(filename) else { throw URLError(.cannotCreateFile) }
        
        if fileManager.fileExists(atPath: saveUrl.path) {
            try? fileManager.removeItem(at: saveUrl)
        }
        
        try fileManager.moveItem(at: tempUrl, to: saveUrl)
        print("✅ Сохранено: \(saveUrl.path)")
        
        return saveUrl
    }
}
