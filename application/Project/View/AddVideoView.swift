//
//  AddVideoView.swift
//  Project
//
//  Created by Даниил on 23.12.2025.
//

import SwiftUI
import PhotosUI
import AVKit

struct AddVideoView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var descriptionText = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedVideoURL: URL?
    @State private var isSaving = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ChristmasBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if let url = selectedVideoURL {
                        ZStack(alignment: .topTrailing) {
                            VideoPlayer(player: AVPlayer(url: url))
                                .frame(height: 300)
                                .cornerRadius(12)
                            
                            Button(action: {
                                selectedVideoURL = nil
                                selectedItem = nil
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding(8)
                            }
                        }
                    } else {
                        PhotosPicker(selection: $selectedItem, matching: .videos) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.5))
                                    .frame(height: 300)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                            .foregroundColor(Color(red: 0.35, green: 0.18, blue: 0.05))
                                    )
                                
                                VStack {
                                    Image(systemName: "plus.viewfinder")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color(red: 0.11, green: 0.38, blue: 0.19))
                                    Text("Выбрать видео")
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.11, green: 0.38, blue: 0.19))
                                }
                            }
                        }
                    }
                    
                    TextField("Напиши рецепт или описание...", text: $descriptionText, axis: .vertical)
                        .lineLimit(3...6)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: saveVideo) {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Опубликовать")
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((selectedVideoURL == nil || descriptionText.isEmpty) ? Color.gray : Color(red: 0.11, green: 0.38, blue: 0.19))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(selectedVideoURL == nil || descriptionText.isEmpty || isSaving)
                }
                .padding()
            }
            .navigationTitle("Новый рецепт")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") { dismiss() }
                        .foregroundColor(Color(red: 0.35, green: 0.18, blue: 0.05))
                }
            }
            .onChange(of: selectedItem) { newItem in
                guard let newItem = newItem else { return }
                
                Task {
                    if let movie = try? await newItem.loadTransferable(type: MovieTransferable.self) {
                        await MainActor.run {
                            self.selectedVideoURL = movie.url
                        }
                    }
                }
            }
        }
        .onAppear {
             UINavigationBar.appearance().backgroundColor = .clear
             UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
             UINavigationBar.appearance().shadowImage = UIImage()
        }
    }
    
    private func saveVideo() {
        guard let tempUrl = selectedVideoURL else { return }
        isSaving = true
        
        Task {
            if let savedFileName = StorageService.shared.saveVideoToDocuments(from: tempUrl) {
                StorageService.shared.addNewVideo(filename: savedFileName, description: descriptionText)
                
                await MainActor.run {
                    isSaving = false
                    dismiss()
                }
            }
        }
    }
}

struct MovieTransferable: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = FileManager.default.temporaryDirectory.appendingPathComponent(received.file.lastPathComponent)
            if FileManager.default.fileExists(atPath: copy.path) {
                try? FileManager.default.removeItem(at: copy)
            }
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self(url: copy)
        }
    }
}

