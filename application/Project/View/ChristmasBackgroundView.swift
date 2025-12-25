//
//  ChristmasBackgroundView.swift
//  Project
//
//  Created by Даниил on 23.12.2025.
//

import UIKit

class ChristmasBackgroundView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    private lazy var garlandImageView: UIImageView = {
        let image = UIImage(named: AppTheme.Images.garland)
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.alpha = 0.8
        return iv
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial) // Адаптивный блюр
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.insertSublayer(gradientLayer, at: 0)
        
        addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        addSubview(garlandImageView)
        NSLayoutConstraint.activate([
            garlandImageView.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            garlandImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            garlandImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            garlandImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        updateGradientColors()
        startGarlandAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateGradientColors()
    }

    func updateGradientColors() {
        if traitCollection.userInterfaceStyle == .dark {
            let topColor = UIColor(red: 0.05, green: 0.12, blue: 0.25, alpha: 1.0).cgColor
            let bottomColor = UIColor(red: 0.1, green: 0.05, blue: 0.15, alpha: 1.0).cgColor
            gradientLayer.colors = [topColor, bottomColor]
        } else {
            gradientLayer.colors = [
                AppTheme.Colors.backgroundStart.cgColor,
                AppTheme.Colors.backgroundEnd.cgColor
            ]
        }
    }
    
    private func startGarlandAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            self.garlandImageView.alpha = 0.4
        }, completion: nil)
    }
    
    // Автоматически реагируем на системную смену темы
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateGradientColors()
        }
    }
}
