import SwiftUI
import AVKit

struct ProfileView: View {
    @State private var recipes: [Recipe] = []
    @State private var selectedTab = 0
    
    @Environment(\.colorScheme) var colorScheme
    var iceColor: Color {
        colorScheme == .dark ? Color(red: 0.2, green: 0.2, blue: 0.25) : Color(red: 0.85, green: 0.92, blue: 1.0)
    }
    var chocolateColor: Color {
        colorScheme == .dark ? .white : Color(red: 0.35, green: 0.18, blue: 0.05)
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var filteredRecipes: [Recipe] {
        switch selectedTab {
        case 0: return recipes.filter { $0.isMyVideo }
        case 1: return recipes.filter { $0.isLiked }
        case 2: return recipes.filter { $0.isSaved }
        default: return []
        }
    }
    
    var myVideosCount: Int { recipes.filter { $0.isMyVideo }.count }
    var likesCount: Int { recipes.filter { $0.isLiked }.count }
    
    var body: some View {
        NavigationView {
            ZStack {
                ChristmasBackground()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        ZStack(alignment: .trailing) {
                            Text("@JingleEat")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(chocolateColor)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 10)
                            
                            // Кнопка настроек
                            NavigationLink(destination: SettingsView()) {
                                HStack(spacing: 6) {
                                    Text("settings")
                                        .font(.system(size: 14, weight: .medium))
                                    Image("settings")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 18, height: 18)
                                }
                                .foregroundColor(chocolateColor)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(iceColor)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 40)

                        HStack(alignment: .center, spacing: 20) {
                            Image("tap_profile_green")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .background(Color.white.opacity(0.85))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            
                            HStack(spacing: 15) {
                                StatView(value: "\(myVideosCount)", title: "Рецептов")
                                StatView(value: "\(likesCount)", title: "Лайков")
                                // ИЗМЕНЕНИЕ 2: Убрали "Сохраненные"
                                StatView(value: "50k", title: "Подписч.")
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        HStack(spacing: 12) {
                            SmallTabButton(icon: "square.grid.3x3.fill", isSelected: selectedTab == 0) { selectedTab = 0 }
                            SmallTabButton(icon: "heart.fill", isSelected: selectedTab == 1) { selectedTab = 1 }
                            SmallTabButton(icon: "bookmark.fill", isSelected: selectedTab == 2) { selectedTab = 2 }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        Rectangle()
                            .fill(chocolateColor.opacity(0.1))
                            .frame(height: 1)
                            .padding(.horizontal, 20)

                        // === СЕТКА ===
                        if filteredRecipes.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "video.slash")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text("Здесь пока пусто")
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 60)
                        } else {
                            LazyVGrid(columns: columns, spacing: 2) {
                                ForEach(filteredRecipes) { recipe in
                                    NavigationLink(destination: SingleVideoView(recipe: recipe)) {
                                        VideoThumbnail(recipe: recipe)
                                            .frame(height: 180)
                                            .clipped()
                                    }
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear { loadData() }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RecipesUpdated"))) { _ in loadData() }
    }
    
    private func loadData() {
        recipes = StorageService.shared.loadRecipes()
    }
}

struct SmallTabButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    private let chocolate = Color(red: 0.35, green: 0.18, blue: 0.05)
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(
                    isSelected
                    ? (colorScheme == .dark ? chocolate : .white)
                    : (colorScheme == .dark ? .white : chocolate)
                )
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    isSelected
                    ? (colorScheme == .dark ? .white : chocolate)
                    : (colorScheme == .dark ? Color.white.opacity(0.15) : Color.white.opacity(0.5))
                )
                .cornerRadius(12)
        }
    }
}

struct StatView: View {
    let value: String
    let title: String
    
    @Environment(\.colorScheme) var colorScheme
    var chocolateColor: Color {
        colorScheme == .dark ? .white : Color(red: 0.35, green: 0.18, blue: 0.05)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 17, weight: .bold)).foregroundColor(chocolateColor)
            Text(title).font(.system(size: 10)).foregroundColor(.gray).lineLimit(1).minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

struct VideoThumbnail: View {
    let recipe: Recipe
    @State private var image: UIImage?
    var body: some View {
        ZStack {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.white.opacity(0.1)
                ProgressView()
            }
        }
        .onAppear { generateThumbnail() }
    }
    private func generateThumbnail() {
        guard image == nil, let url = recipe.smartURL else { return }
        Task.detached(priority: .background) {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            if let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 1, preferredTimescale: 60), actualTime: nil) {
                let uiImage = UIImage(cgImage: cgImage)
                await MainActor.run { self.image = uiImage }
            }
        }
    }
}

struct SingleVideoView: View {
    let recipe: Recipe
    var body: some View {
        TikTokCell(recipe: recipe)
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
    }
}
