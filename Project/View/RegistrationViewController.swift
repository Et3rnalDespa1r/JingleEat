//
//  RegistrationViewController.swift
//  Project
//
//  Created by Даниил on 20.12.2025.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let viewModel = RegistrationViewModel()
    private let gradientLayer = CAGradientLayer()
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(red: 0.35, green: 0.18, blue: 0.05, alpha: 1.0)
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
    
    // Лейбл для вывода ошибок (красный текст)
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true // Скрыт, пока нет ошибки
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.backgroundColor = UIColor(red: 0.11, green: 0.38, blue: 0.19, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.alpha = 0.5
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var garlandImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "garland"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 0.35, green: 0.18, blue: 0.05, alpha: 1.0) // Твой шоколадный цвет
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
        setupBackground()
        view.addSubview(garlandImageView)
        view.addSubview(backButton)
        setupLayout()
    }
    
    // MARK: - Actions
    
    @objc private func fieldsChanged() {
        viewModel.email = emailField.text ?? ""
        viewModel.password = passwordField.text ?? ""
        
        errorLabel.isHidden = true
        
        let isValid = viewModel.email.contains("@") && viewModel.password.count >= 6
        registerButton.isEnabled = isValid
        UIView.animate(withDuration: 0.2) {
            self.registerButton.alpha = isValid ? 1.0 : 0.5
        }
    }
    
    @objc private func registerTapped() {

        if viewModel.validateAndRegister() {
            print("Успешная регистрация!")
            self.dismiss(animated: true)
        } else {
            errorLabel.text = viewModel.errorMessage
            errorLabel.isHidden = false
        }
    }
    
    // MARK: - Layout & Setup
    
    private func setupLayout() {
        [titleLabel, emailField, passwordField, errorLabel, registerButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            garlandImageView.topAnchor.constraint(equalTo: view.topAnchor),
            garlandImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            garlandImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            garlandImageView.heightAnchor.constraint(equalToConstant: 120),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
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
    
    private func setupBackground() {
        view.backgroundColor = UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0)
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0).cgColor,
            UIColor.white.cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.alpha = 0.5
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 1)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    // MARK: - animation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.garlandImageView.alpha = 0.6
        }, completion: nil)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
