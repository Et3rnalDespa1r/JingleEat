import Foundation
import AVKit
import Combine

@MainActor
class VideoPlayerManager: ObservableObject {
    static let shared = VideoPlayerManager()
    
    private var playerItemsCache: [URL: AVPlayerItem] = [:]
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

        if let cachedItem = playerItemsCache[url] {
            setupPlayer(with: cachedItem)
        } else {
            let asset = AVURLAsset(url: url)
            asset.loadValuesAsynchronously(forKeys: ["playable"]) { [weak self] in
                Task { @MainActor in
                    let item = AVPlayerItem(asset: asset)
                    self?.playerItemsCache[url] = item
                    if self?.currentUrl == url {
                        self?.setupPlayer(with: item)
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
