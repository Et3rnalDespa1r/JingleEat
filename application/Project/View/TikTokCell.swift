import SwiftUI
import AVKit
import Photos

import SwiftUI
import AVKit
import Photos

struct TikTokCell: View {
    let recipe: Recipe
    @ObservedObject var playerManager = VideoPlayerManager.shared
    @State private var isPaused = false
    @State private var isExpanded = false
    @State private var isProcessing = false
    @State private var showSavedAlert = false
    
    @State private var isLiked = false
    @State private var isSaved = false
    
    let tabBarHeight: CGFloat = 90
    
    var body: some View {
        ZStack {
            Color.black
            
            if let player = playerManager.currentPlayer {
                VideoPlayerRepresentable(player: player)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(false)
            } else {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
            
            if isPaused && !isExpanded {
                Image(systemName: "play.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(radius: 10)
                    .scaleEffect(isPaused ? 1.0 : 0.5)
                    .opacity(isPaused ? 1 : 0)
                    .animation(.spring(), value: isPaused)
            }
            
            if isProcessing {
                ZStack {
                    Color.black.opacity(0.4)
                    ProgressView()
                        .tint(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            
            if showSavedAlert {
                VStack {
                    Image(systemName: "checkmark")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    Text("Saved!")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .transition(.scale.combined(with: .opacity))
                .zIndex(100)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { showSavedAlert = false }
                    }
                }
            }
            
            VStack {
                Spacer()
                interfaceOverlay
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isExpanded {
                withAnimation { isExpanded = false }
            } else {
                togglePlayPause()
            }
        }
        .onAppear {
             isPaused = false
             isLiked = recipe.isLiked
             isSaved = recipe.isSaved
        }
        .onChange(of: playerManager.currentPlayer?.rate) { oldValue, newRate in
            isPaused = newRate == 0
        }
    }
    
    private func togglePlayPause() {
        guard let player = playerManager.currentPlayer else { return }
        
        if player.timeControlStatus == .playing {
            player.pause()
            isPaused = true
        } else {
            player.play()
            isPaused = false
        }
    }
    
    private func toggleLike() {
        withAnimation(.spring()) {
            isLiked.toggle()
        }
        StorageService.shared.toggleLike(for: recipe)
    }
    
    private func toggleSave() {
        withAnimation(.spring()) {
            isSaved.toggle()
        }
        StorageService.shared.toggleSave(for: recipe)
    }
    
    private func downloadToGallery() {
        isProcessing = true
        
        Task {
            let videoURL: URL
            if let localPath = VideoLoader.shared.getCachedPath(for: recipe.videoUrl) {
                videoURL = localPath
            } else {
                do {
                    videoURL = try await VideoLoader.shared.downloadVideo(from: recipe.videoUrl)
                } catch {
                    await MainActor.run { isProcessing = false }
                    return
                }
            }
            
            do {
                try await PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
                }
                await MainActor.run {
                    isProcessing = false
                    withAnimation { showSavedAlert = true }
                }
            } catch {
                await MainActor.run { isProcessing = false }
            }
        }
    }
    
    private func shareVideo() {
        isProcessing = true
        Task {
            if let localPath = VideoLoader.shared.getCachedPath(for: recipe.videoUrl) {
                await MainActor.run {
                    isProcessing = false
                    presentShareSheet(url: localPath)
                }
                return
            }
            
            do {
                let downloadedPath = try await VideoLoader.shared.downloadVideo(from: recipe.videoUrl)
                await MainActor.run {
                    isProcessing = false
                    presentShareSheet(url: downloadedPath)
                }
            } catch {
                await MainActor.run { isProcessing = false }
            }
        }
    }
    
    private func presentShareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
    
    private var isTextLong: Bool {
        return recipe.description.count > 60 || recipe.description.contains("\n")
    }
    
    private var icyAvatarView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color(red: 0.6, green: 0.85, blue: 1.0)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                )
                .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.5), radius: 4, x: 0, y: 0)
            
            Image("tap_profile_green")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 36, height: 36)
                .clipShape(Circle())
        }
    }
    
    private var interfaceOverlay: some View {
        ZStack(alignment: .bottomLeading) {
            if !isExpanded {
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 250)
                .allowsHitTesting(false)
            }
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 10) {
                        icyAvatarView
                        
                        Text(recipe.userName)
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                    
                    Group {
                        if isExpanded {
                            ScrollView {
                                Text(recipe.description)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.bottom, 20)
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.5)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(12)
                        } else {
                            Text(recipe.description)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .shadow(radius: 2)
                        }
                    }
                    .onTapGesture {
                        if isTextLong {
                            withAnimation(.spring()) { isExpanded.toggle() }
                        }
                    }
                    
                    if isTextLong {
                        Button(action: {
                            withAnimation(.spring()) { isExpanded.toggle() }
                        }) {
                            Text(isExpanded ? "Скрыть" : "Ещё")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.bottom, isExpanded ? tabBarHeight : 110)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !isExpanded {
                    VStack(spacing: 25) {
                        Button(action: { toggleLike() }) {
                            SideButton(icon: isLiked ? "heart.fill" : "heart", text: "Like", color: isLiked ? .red : .white)
                        }
                        
                        SideButton(icon: "bubble.right.fill", text: "Chat")
                        
                        Button(action: { toggleSave() }) {
                            SideButton(icon: isSaved ? "bookmark.fill" : "bookmark", text: "Save", color: isSaved ? .yellow : .white)
                        }
                        
                        Button(action: {
                            shareVideo()
                        }) {
                            SideButton(icon: "arrowshape.turn.up.right.fill", text: "Share")
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 130)
                }
            }
        }
    }
}

struct SideButton: View {
    let icon: String
    let text: String
    var color: Color = .white
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
                .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
            
            Text(text)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
        }
    }
}
