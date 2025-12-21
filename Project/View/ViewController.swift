//
//  ViewController.swift
//  Project
//
//  Created by Даниил on 19.12.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - UI Elements
    
    private lazy var garlandImageView: UIImageView = {
        let iv = UIImageView(image: viewModel.garlandImage)
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.titleText
        label.font = .systemFont(ofSize: 38, weight: .black)
        label.textColor = viewModel.titleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.descriptionText
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = viewModel.descriptionColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gingerbreadImageView: UIImageView = {
        let iv = UIImageView(image: viewModel.gingerImage)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        
        [garlandImageView, titleLabel, gingerbreadImageView, descriptionLabel, registerButton, loginButton].forEach {
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    
    @objc private func didTapRegister() {
        viewModel.registerTapped()
        let vc = RegistrationViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc private func didTapLogin() {
        viewModel.loginTapped()
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupBackground() {
        // 1. Установи основной цвет вьюхи белым или светло-голубым,
        // чтобы блюру было что "размывать" кроме темноты
        view.backgroundColor = UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0)
        
        // 2. Градиент
        gradientLayer.colors = [
            UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0).cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // 3. Блюр (сделай его поярче)
        let blurEffect = UIBlurEffect(style: .light) // Попробуй .light вместо .extraLight
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.alpha = 0.6 // Увеличь альфу, чтобы скрыть "грязь" под ним
        view.insertSubview(blurView, at: 1)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.gingerbreadImageView.transform = .identity
        self.gingerbreadImageView.alpha = 1.0
        UIView.animate(withDuration: 2.0, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            let rotation = CGAffineTransform(rotationAngle: 0.05)
            let scale = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.gingerbreadImageView.transform = rotation.concatenating(scale)
        }, completion: nil)
        self.garlandImageView.alpha = 1.0
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.garlandImageView.alpha = 0.8
        }, completion: nil)
    }
}
