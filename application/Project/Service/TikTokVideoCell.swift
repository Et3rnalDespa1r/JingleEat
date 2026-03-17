//
//  Untitled.swift
//  Project
//
//  Created by Даниил on 22.12.2025.
//

import UIKit
import AVFoundation

class TikTokVideoCell: UITableViewCell {
    
    private let playerContainer = UIView()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var loopObserver: NSObjectProtocol?
    
    private let playIcon = UIImageView(image: UIImage(systemName: "play.fill"))
    private let bottomGradient = CAGradientLayer()
    
    private let usernameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let rightStack = UIStackView()
    
    private let likeButton = UIButton(type: .custom)
    private let saveButton = UIButton(type: .custom)
    private let shareButton = UIButton(type: .custom)
    
    private var recipe: Recipe?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .black
        contentView.backgroundColor = .black
        
        playerContainer.backgroundColor = .black
        playerContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playerContainer)
        
        contentView.layer.addSublayer(bottomGradient)
        bottomGradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        
        playIcon.tintColor = UIColor.white.withAlphaComponent(0.8)
        playIcon.isHidden = true
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playIcon)
        
        usernameLabel.font = .boldSystemFont(ofSize: 16)
        usernameLabel.textColor = .white
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(usernameLabel)
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        rightStack.axis = .vertical
        rightStack.spacing = 25
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightStack)
        
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        likeButton.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
        likeButton.tintColor = .white
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        saveButton.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        saveButton.tintColor = .white
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill", withConfiguration: config), for: .normal)
        shareButton.tintColor = .white
        
        rightStack.addArrangedSubview(likeButton)
        rightStack.addArrangedSubview(saveButton)
        rightStack.addArrangedSubview(shareButton)
        
        NSLayoutConstraint.activate([
            playerContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            playIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 60),
            playIcon.heightAnchor.constraint(equalToConstant: 60),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -110),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: rightStack.leadingAnchor, constant: -16),
            
            usernameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8),
            usernameLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            
            rightStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -130),
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(togglePlayPause))
        contentView.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = playerContainer.bounds
        bottomGradient.frame = CGRect(x: 0, y: bounds.height - 250, width: bounds.width, height: 250)
    }
    
    func configure(with recipe: Recipe) {
        self.recipe = recipe
        usernameLabel.text = "@\(recipe.userName)"
        descriptionLabel.text = recipe.description
        updateButtons()
        
        guard let url = VideoService.shared.getAppropriateURL(for: recipe) else { return }
        
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let layer = playerLayer {
            playerContainer.layer.addSublayer(layer)
        }
        setNeedsLayout()
        
        if let observer = loopObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        loopObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: item, queue: .main) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
    }
    
    func play() {
        player?.play()
        playIcon.isHidden = true
    }
    
    func pause() {
        player?.pause()
        playIcon.isHidden = false
    }
    
    @objc private func togglePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            pause()
        } else {
            play()
        }
    }
    
    @objc private func likeTapped() {
        guard let recipe = recipe else { return }
        StorageService.shared.toggleLike(for: recipe)
        self.recipe?.isLiked.toggle()
        updateButtons()
    }
    
    @objc private func saveTapped() {
        guard let recipe = recipe else { return }
        StorageService.shared.toggleSave(for: recipe)
        self.recipe?.isSaved.toggle()
        updateButtons()
    }
    
    private func updateButtons() {
        guard let recipe = recipe else { return }
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        likeButton.setImage(UIImage(systemName: recipe.isLiked ? "heart.fill" : "heart", withConfiguration: config), for: .normal)
        likeButton.tintColor = recipe.isLiked ? .systemRed : .white
        
        saveButton.setImage(UIImage(systemName: recipe.isSaved ? "bookmark.fill" : "bookmark", withConfiguration: config), for: .normal)
        saveButton.tintColor = recipe.isSaved ? .systemYellow : .white
    }
}
