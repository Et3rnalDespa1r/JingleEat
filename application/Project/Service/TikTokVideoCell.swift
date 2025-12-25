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
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.11, green: 0.38, blue: 0.19, alpha: 1.0) 
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        playerContainer.backgroundColor = .black
        playerContainer.layer.cornerRadius = 25
        playerContainer.layer.masksToBounds = true
        
        [playerContainer, captionLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            playerContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            playerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            playerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playerContainer.heightAnchor.constraint(equalToConstant: 450),
            
            captionLabel.topAnchor.constraint(equalTo: playerContainer.bottomAnchor, constant: 12),
            captionLabel.leadingAnchor.constraint(equalTo: playerContainer.leadingAnchor, constant: 10),
            captionLabel.trailingAnchor.constraint(equalTo: playerContainer.trailingAnchor, constant: -10),
            captionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    func configure(with recipe: Recipe) {
        captionLabel.text = recipe.description
        
        guard let url = URL(string: recipe.videoUrl) else { return }
        
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        player = nil

        let headers: [String: String] = [
            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1",
            "Referer": "https://www.tiktok.com/"
        ]
        
        let asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        let playerItem = AVPlayerItem(asset: asset)
        
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = playerContainer.bounds
        
        if let layer = playerLayer {
            playerContainer.layer.addSublayer(layer)
        }
        
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = playerContainer.bounds
    }
}
