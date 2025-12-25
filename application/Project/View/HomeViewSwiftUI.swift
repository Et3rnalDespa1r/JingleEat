import SwiftUI
import AVKit

import SwiftUI
import AVKit

struct HomeViewSwiftUI: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showAddVideo = false
    
    // 1. Следим за темой устройства
    @Environment(\.colorScheme) var colorScheme
    
    // 2. Адаптивный фон шапки (Ледяной днем / Темно-синий ночью)
    var headerBackgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 0.05, green: 0.12, blue: 0.25) // Ночной цвет
            : Color(red: 0.85, green: 0.92, blue: 1.0)  // Дневной ледяной
    }
    
    // 3. Адаптивный цвет текста и иконок (Шоколад днем / Белый ночью)
    var contentColor: Color {
        colorScheme == .dark
            ? .white
            : Color(red: 0.35, green: 0.18, blue: 0.05)
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.recipes) { recipe in
                        TikTokCell(recipe: recipe)
                            .id(recipe.id)
                            .containerRelativeFrame(.vertical, count: 1, spacing: 0)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $viewModel.currentScrollID)
            .onChange(of: viewModel.currentScrollID) { oldValue, newValue in
                viewModel.handleScrollChange(newID: newValue)
            }
            .onAppear {
                if viewModel.currentScrollID == nil {
                    viewModel.handleScrollChange(newID: viewModel.recipes.first?.id)
                }
            }
            .onDisappear {
                VideoPlayerManager.shared.pauseVideo()
            }
            .navigationBarHidden(true)
        }
        .ignoresSafeArea(.all)
        .background(Color.black)
        .sheet(isPresented: $showAddVideo) {
            AddVideoView()
                .onDisappear {
                    viewModel.recipes = StorageService.shared.loadRecipes()
                }
        }
    }
    
    private var headerView: some View {
        ZStack {
            HStack {
                Button(action: {
                    showAddVideo = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(contentColor)
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.5))
                        .clipShape(Circle())
                }
                Spacer()
            }
            
            Text("JingleEat")
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(contentColor)
                .multilineTextAlignment(.center)

            HStack {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(contentColor) // <-- Адаптивный цвет
                        .frame(width: 44, height: 44)
                        .background(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.5))
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
        .padding(.top, 60)
        .background(headerBackgroundColor)
        .zIndex(10)
    }
}
