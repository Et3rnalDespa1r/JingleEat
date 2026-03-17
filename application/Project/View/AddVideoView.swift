//
//  AddVideoView.swift
//  Project
//
//  Created by Даниил on 23.12.2025.
//

import UIKit
import PhotosUI
import AVKit

class AddVideoViewController: UIViewController, PHPickerViewControllerDelegate {
    private let backgroundView = ChristmasBackgroundView()
    private let videoContainer = UIView()
    private let selectButton = UIButton(type: .system)
    private let descriptionTextView = UITextView()
    private let publishButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    
    private var playerViewController: AVPlayerViewController?
    private var selectedVideoURL: URL? {
        didSet { updateUI() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        navigationItem.title = "Новый рецепт"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem?.tintColor = AppTheme.Colors.chocolate
        
        videoContainer.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        videoContainer.layer.cornerRadius = 12
        videoContainer.layer.borderWidth = 2
        videoContainer.layer.borderColor = AppTheme.Colors.chocolate.cgColor
        videoContainer.clipsToBounds = true
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoContainer)
        
        selectButton.setTitle("Выбрать видео", for: .normal)
        selectButton.setImage(UIImage(systemName: "plus.viewfinder"), for: .normal)
        selectButton.tintColor = AppTheme.Colors.mainGreen
        selectButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.addTarget(self, action: #selector(selectTapped), for: .touchUpInside)
        videoContainer.addSubview(selectButton)
        
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        closeButton.tintColor = .white
        closeButton.isHidden = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(removeVideo), for: .touchUpInside)
        videoContainer.addSubview(closeButton)
        
        descriptionTextView.text = "Напиши рецепт или описание..."
        descriptionTextView.textColor = .lightGray
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        descriptionTextView.layer.cornerRadius = 12
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextView)
        
        publishButton.setTitle("Опубликовать", for: .normal)
        publishButton.backgroundColor = .gray
        publishButton.setTitleColor(.white, for: .normal)
        publishButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        publishButton.layer.cornerRadius = 12
        publishButton.isEnabled = false
        publishButton.translatesAutoresizingMaskIntoConstraints = false
        publishButton.addTarget(self, action: #selector(publishTapped), for: .touchUpInside)
        view.addSubview(publishButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            videoContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            videoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            videoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            videoContainer.heightAnchor.constraint(equalToConstant: 300),
            
            selectButton.centerXAnchor.constraint(equalTo: videoContainer.centerXAnchor),
            selectButton.centerYAnchor.constraint(equalTo: videoContainer.centerYAnchor),
            
            closeButton.topAnchor.constraint(equalTo: videoContainer.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -8),
            
            descriptionTextView.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            publishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            publishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            publishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            publishButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func selectTapped() {
        var config = PHPickerConfiguration()
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func removeVideo() {
        selectedVideoURL = nil
        playerViewController?.view.removeFromSuperview()
        playerViewController?.removeFromParent()
        playerViewController = nil
    }
    
    private func updateUI() {
        let hasVideo = selectedVideoURL != nil
        selectButton.isHidden = hasVideo
        closeButton.isHidden = !hasVideo
        publishButton.backgroundColor = hasVideo ? AppTheme.Colors.mainGreen : .gray
        publishButton.isEnabled = hasVideo
        
        if let url = selectedVideoURL {
            let player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = player
            vc.view.frame = videoContainer.bounds
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addChild(vc)
            videoContainer.insertSubview(vc.view, belowSubview: closeButton)
            vc.didMove(toParent: self)
            playerViewController = vc
        }
    }
    
    @objc private func publishTapped() {
        guard let url = selectedVideoURL else { return }
        publishButton.setTitle("Сохранение...", for: .normal)
        publishButton.isEnabled = false
        
        Task {
            if let savedFileName = StorageService.shared.saveVideoToDocuments(from: url) {
                StorageService.shared.addNewVideo(filename: savedFileName, description: descriptionTextView.text ?? "")
                await MainActor.run {
                    dismiss(animated: true)
                }
            }
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider else { return }
        provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { [weak self] url, error in
            guard let url = url else { return }
            let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
            try? FileManager.default.removeItem(at: tempDir)
            try? FileManager.default.copyItem(at: url, to: tempDir)
            DispatchQueue.main.async {
                self?.selectedVideoURL = tempDir
            }
        }
    }
}
