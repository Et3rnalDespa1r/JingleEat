//
//  ViewController.swift
//  Project
//
//  Created by Даниил on 19.12.2025.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let gradientLayer = CAGradientLayer()
    
    private let garlandImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "garland"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "JingleEat 🎄"
        label.font = .systemFont(ofSize: 38, weight: .black) // Сделали жирнее
        label.textColor = UIColor(red: 0.35, green: 0.18, blue: 0.05, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Получайте вдохновления для праздничного стола вместе с JingleEat!"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 0.55, green: 0.35, blue: 0.25, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gingerbreadImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ginger"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.backgroundColor = UIColor(red: 0.11, green: 0.38, blue: 0.19, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0).cgColor
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.2
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = UIColor(red: 0.76, green: 0.15, blue: 0.15, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 2.5
        button.layer.borderColor = UIColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1.0).cgColor
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.2
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        
        view.addSubview(garlandImageView)
        view.addSubview(titleLabel)
        view.addSubview(gingerbreadImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGingerAnimation()
    }
    
    // MARK: - Setup
    
    private func setupBackground() {
        gradientLayer.colors = [
            UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0).cgColor, UIColor.white.cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.alpha = 0.4
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 1)
        
        let ice = UIView(frame: view.bounds)
        ice.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        ice.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(ice, at: 2)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            garlandImageView.topAnchor.constraint(equalTo: view.topAnchor),
            garlandImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            garlandImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            garlandImageView.heightAnchor.constraint(equalToConstant: 160),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            gingerbreadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gingerbreadImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            gingerbreadImageView.widthAnchor.constraint(equalToConstant: 320),
            gingerbreadImageView.heightAnchor.constraint(equalToConstant: 320),
            
            descriptionLabel.topAnchor.constraint(equalTo: gingerbreadImageView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: 280),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            loginButton.widthAnchor.constraint(equalToConstant: 280),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Animations
    
    private func startGingerAnimation() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            
            let rotation = CGAffineTransform(rotationAngle: 0.05)
            let scale = CGAffineTransform(scaleX: 1.05, y: 1.05)
            
            self.gingerbreadImageView.transform = rotation.concatenating(scale)
            
        }, completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.garlandImageView.alpha = 0.8
        }, completion: nil)
    }
}
