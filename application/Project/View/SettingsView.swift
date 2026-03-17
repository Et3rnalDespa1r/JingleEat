import UIKit

class SettingsViewController: UIViewController {
    private let backgroundView = ChristmasBackgroundView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let containerView = UIView()
    private let themeIcon = UIImageView()
    private let themeLabel = UILabel()
    private let themeSwitch = UISwitch()
    private let logoutButton = UIButton(type: .system)
    
    private let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateAppTheme(isDark: viewModel.isDarkMode)
    }
    
    private func setupUI() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        let contentColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : AppTheme.Colors.chocolate
        let cardBgColor = traitCollection.userInterfaceStyle == .dark ? UIColor.black.withAlphaComponent(0.4) : UIColor.white.withAlphaComponent(0.85)
        
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), for: .normal)
        backButton.tintColor = contentColor
        backButton.backgroundColor = cardBgColor
        backButton.layer.cornerRadius = 22
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        titleLabel.text = "Настройки"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = contentColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        containerView.backgroundColor = cardBgColor
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        themeIcon.image = UIImage(systemName: viewModel.isDarkMode ? "moon.fill" : "sun.max.fill")
        themeIcon.tintColor = contentColor
        themeIcon.contentMode = .scaleAspectFit
        themeIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(themeIcon)
        
        themeLabel.text = "Ночная тема"
        themeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        themeLabel.textColor = contentColor
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(themeLabel)
        
        themeSwitch.isOn = viewModel.isDarkMode
        themeSwitch.onTintColor = contentColor
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        themeSwitch.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        containerView.addSubview(themeSwitch)
        
        logoutButton.setTitle("Выйти", for: .normal)
        logoutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        logoutButton.tintColor = .white
        logoutButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.85)
        logoutButton.layer.cornerRadius = 16
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            containerView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            themeIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            themeIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            themeIcon.widthAnchor.constraint(equalToConstant: 30),
            themeIcon.heightAnchor.constraint(equalToConstant: 30),
            
            themeLabel.leadingAnchor.constraint(equalTo: themeIcon.trailingAnchor, constant: 10),
            themeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            themeSwitch.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            themeSwitch.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func themeChanged(_ sender: UISwitch) {
        viewModel.isDarkMode = sender.isOn
        themeIcon.image = UIImage(systemName: sender.isOn ? "moon.fill" : "sun.max.fill")
        updateAppTheme(isDark: sender.isOn)
    }
    
    private func updateAppTheme(isDark: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }, completion: nil)
    }
    
    @objc private func logoutTapped() {
        viewModel.clearUserData()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let loginVC = ViewController()
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
            window.rootViewController = loginVC
        }, completion: nil)
    }
}
