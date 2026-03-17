import Foundation
import AVKit
import Combine

@MainActor
class VideoPlayerManager: ObservableObject {
    static let shared = VideoPlayerManager()
    
    // 1. Кэшируем AVAsset, а не AVPlayerItem
    private var assetsCache: [URL: AVAsset] = [:]
    @Published var currentPlayer: AVPlayer?
    private var currentUrl: URL?
    private var loopObserver: NSObjectProtocol?
    
    private let loadingQueue = DispatchQueue(label: "com.project.videoLoading", qos: .userInitiated)

    func playVideo(at url: URL) {
        if currentUrl == url {
            currentPlayer?.play()
            return
        }

        pauseVideo()
        currentUrl = url

        // 2. Если ассет в кэше есть, создаем из него НОВЫЙ AVPlayerItem
        if let cachedAsset = assetsCache[url] {
            let item = AVPlayerItem(asset: cachedAsset)
            setupPlayer(with: item)
        } else {
            // 3. Если нет - загружаем, сохраняем в кэш и создаем AVPlayerItem
            let asset = AVURLAsset(url: url)
            asset.loadValuesAsynchronously(forKeys: ["playable"]) { [weak self] in
                Task { @MainActor in
                    guard let self = self else { return }
                    self.assetsCache[url] = asset
                    
                    if self.currentUrl == url {
                        let item = AVPlayerItem(asset: asset)
                        self.setupPlayer(with: item)
                    }
                }
            }
        }
    }

    func pauseVideo() {
        currentPlayer?.pause()
    }

    private func setupPlayer(with item: AVPlayerItem) {
        let player = AVPlayer(playerItem: item)
        
        if let observer = loopObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        loopObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak player] _ in
            player?.seek(to: .zero)
            player?.play()
        }
        
        self.currentPlayer = player
        player.play()
    }
}
