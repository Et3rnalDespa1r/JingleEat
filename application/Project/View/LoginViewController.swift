//
//  LoginViewController.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//


import UIKit

class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    
    private let backgroundView = ChristmasBackgroundView()
    
    // MARK: - UI Elements
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = AppTheme.Colors.chocolate
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppTheme.Colors.chocolate
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = viewModel.emailPlaceholder
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        tf.layer.cornerRadius = 15
        tf.setLeftPaddingPoints(15)
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 55).isActive = true
        tf.addTarget(self, action: #selector(fieldsChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = viewModel.passwordPlaceholder
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        tf.layer.cornerRadius = 15
        tf.setLeftPaddingPoints(15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.heightAnchor.constraint(equalToConstant: 55).isActive = true
        tf.addTarget(self, action: #selector(fieldsChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.backgroundColor = AppTheme.Colors.mainGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.alpha = 0.5
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc private func handleBack() {
        dismiss(animated: true)
    }
    
    @objc private func fieldsChanged() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
        
        let isValid = !viewModel.email.isEmpty && !viewModel.password.isEmpty
        loginButton.isEnabled = isValid
        UIView.animate(withDuration: 0.2) {
            self.loginButton.alpha = isValid ? 1.0 : 0.5
        }
    }
    
    @objc private func loginTapped() {
        if viewModel.login() {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                guard let window = sceneDelegate.window else { return }
                let mainVC = MainTabBarController()
                
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = mainVC
                }, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Ошибка", message: viewModel.errorMessage ?? "Неверные данные", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Layout
    
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        [backButton, titleLabel, emailTextField, passwordTextField, loginButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
}
