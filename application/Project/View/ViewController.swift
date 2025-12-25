//
//  ViewController.swift
//  Project
//
//  Created by Даниил on 19.12.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private let backgroundView = ChristmasBackgroundView()
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "JingleEat 🎄"
        label.font = .systemFont(ofSize: 38, weight: .black)
        label.textColor = AppTheme.Colors.chocolate
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Получайте вдохновения для праздничного стола вместе с JingleEat!"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? .white.withAlphaComponent(0.8)
                : UIColor(red: 0.55, green: 0.35, blue: 0.25, alpha: 1.0)
        }
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gingerbreadImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ginger")) //
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var registerButton: UIButton = {
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
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
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
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startGingerAnimation()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(gingerbreadImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            
            gingerbreadImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gingerbreadImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            gingerbreadImageView.widthAnchor.constraint(equalToConstant: 280),
            gingerbreadImageView.heightAnchor.constraint(equalToConstant: 280),
            
            descriptionLabel.topAnchor.constraint(equalTo: gingerbreadImageView.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Кнопка Регистрации (над кнопкой Входа)
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: 280),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Кнопка Входа (внизу)
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
    }
    
    // MARK: - Actions
    
    @objc private func handleLogin() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    @objc private func handleRegister() {
        let regVC = RegistrationViewController()
        regVC.modalPresentationStyle = .fullScreen
        present(regVC, animated: true)
    }
}

