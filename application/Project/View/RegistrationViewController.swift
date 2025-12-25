//
//  RegistrationViewController.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let viewModel = RegistrationViewModel()
    
    private let backgroundView = ChristmasBackgroundView()
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = AppTheme.Colors.chocolate
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = viewModel.emailPlaceholder
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        tf.layer.cornerRadius = 15
        tf.setLeftPaddingPoints(15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(fieldsChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = viewModel.passwordPlaceholder
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        tf.layer.cornerRadius = 15
        tf.setLeftPaddingPoints(15)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(fieldsChanged), for: .editingChanged)
        return tf
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.backgroundColor = AppTheme.Colors.mainGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.alpha = 0.5
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = AppTheme.Colors.chocolate
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return button
    }()

    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Actions
    
    @objc private func fieldsChanged() {
        viewModel.email = emailField.text ?? ""
        viewModel.password = passwordField.text ?? ""
        
        errorLabel.isHidden = true
        
        let isValid = AuthService.shared.isValidEmail(viewModel.email) && viewModel.password.count >= 6
        registerButton.isEnabled = isValid
        UIView.animate(withDuration: 0.2) {
            self.registerButton.alpha = isValid ? 1.0 : 0.5
        }
    }
    
    @objc private func registerTapped() {
        if viewModel.register() {
            let alert = UIAlertController(title: "Успех", message: "Вы зарегистрированы!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default) { _ in
                self.dismiss(animated: true)
            })
            present(alert, animated: true)
        } else {
            errorLabel.text = viewModel.errorMessage
            errorLabel.isHidden = false
        }
    }
    
    // MARK: - Layout & Setup
    
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        [backButton, titleLabel, emailField, passwordField, errorLabel, registerButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 55),
            
            errorLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 15),
            errorLabel.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            
            registerButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
