import UIKit
import AVFoundation

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let backgroundView = ChristmasBackgroundView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let usernameLabel = UILabel()
    private let settingsButton = UIButton(type: .system)
    private let avatarImageView = UIImageView()
    private let statsStackView = UIStackView()
    private let tabsStackView = UIStackView()
    private var collectionView: UICollectionView!
    
    private var recipes: [Recipe] = []
    private var selectedTab = 0
    private var filteredRecipes: [Recipe] {
        switch selectedTab {
        case 0: return recipes.filter { $0.isMyVideo }
        case 1: return recipes.filter { $0.isLiked }
        case 2: return recipes.filter { $0.isSaved }
        default: return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name("RecipesUpdated"), object: nil)
    }
    
    private func setupUI() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        let chocolateColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white : AppTheme.Colors.chocolate
        let iceColor = traitCollection.userInterfaceStyle == .dark ? UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1.0) : UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0)
        
        usernameLabel.text = "@JingleEat"
        usernameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        usernameLabel.textColor = chocolateColor
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(usernameLabel)
        
        settingsButton.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingsButton.setTitle("settings", for: .normal)
        settingsButton.tintColor = chocolateColor
        settingsButton.backgroundColor = iceColor
        settingsButton.layer.cornerRadius = 12
        settingsButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        contentView.addSubview(settingsButton)
        
        avatarImageView.image = UIImage(named: "tap_profile_green")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        avatarImageView.layer.cornerRadius = 45
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatarImageView)
        
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 15
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsStackView)
        
        tabsStackView.axis = .horizontal
        tabsStackView.distribution = .fillEqually
        tabsStackView.spacing = 12
        tabsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tabsStackView)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoThumbnailCell.self, forCellWithReuseIdentifier: "VideoThumbnailCell")
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            usernameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            settingsButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            settingsButton.heightAnchor.constraint(equalToConstant: 34),
            settingsButton.widthAnchor.constraint(equalToConstant: 90),
            
            avatarImageView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            statsStackView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            statsStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tabsStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            tabsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tabsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tabsStackView.heightAnchor.constraint(equalToConstant: 44),
            
            collectionView.topAnchor.constraint(equalTo: tabsStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),
            collectionView.heightAnchor.constraint(equalToConstant: 500) // Обновляется динамически
        ])
        
        setupTabs()
    }
    
    @objc private func loadData() {
        recipes = StorageService.shared.loadRecipes()
        updateStats()
        updateTabsUI()
        collectionView.reloadData()
        
        let rows = ceil(Double(filteredRecipes.count) / 3.0)
        let height = max(500, rows * 182)
        collectionView.constraints.first { $0.firstAttribute == .height }?.constant = CGFloat(height)
    }
    
    private func updateStats() {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let myCount = recipes.filter { $0.isMyVideo }.count
        let likesCount = recipes.filter { $0.isLiked }.count
        
        statsStackView.addArrangedSubview(createStatView(value: "\(myCount)", title: "Рецептов"))
        statsStackView.addArrangedSubview(createStatView(value: "\(likesCount)", title: "Лайков"))
        statsStackView.addArrangedSubview(createStatView(value: "50k", title: "Подписч."))
    }
    
    private func createStatView(value: String, title: String) -> UIView {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        let valLabel = UILabel()
        valLabel.text = value
        valLabel.font = .systemFont(ofSize: 17, weight: .bold)
        valLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : AppTheme.Colors.chocolate
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 10)
        titleLabel.textColor = .gray
        view.addArrangedSubview(valLabel)
        view.addArrangedSubview(titleLabel)
        return view
    }
    
    private func setupTabs() {
        let icons = ["square.grid.3x3.fill", "heart.fill", "bookmark.fill"]
        for (i, icon) in icons.enumerated() {
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: icon), for: .normal)
            btn.layer.cornerRadius = 12
            btn.tag = i
            btn.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            tabsStackView.addArrangedSubview(btn)
        }
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        selectedTab = sender.tag
        loadData()
    }
    
    private func updateTabsUI() {
        let isDark = traitCollection.userInterfaceStyle == .dark
        let choc = AppTheme.Colors.chocolate
        
        for (i, view) in tabsStackView.arrangedSubviews.enumerated() {
            guard let btn = view as? UIButton else { continue }
            let isSelected = i == selectedTab
            btn.tintColor = isSelected ? (isDark ? choc : .white) : (isDark ? .white : choc)
            btn.backgroundColor = isSelected ? (isDark ? .white : choc) : (isDark ? UIColor.white.withAlphaComponent(0.15) : UIColor.white.withAlphaComponent(0.5))
        }
    }
    
    @objc private func openSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoThumbnailCell", for: indexPath) as! VideoThumbnailCell
        cell.configure(with: filteredRecipes[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 4) / 3
        return CGSize(width: width, height: 180)
    }
}

class VideoThumbnailCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let loader = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loader)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loader.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with recipe: Recipe) {
        imageView.image = nil
        loader.startAnimating()
        guard let url = recipe.smartURL else { return }
        
        Task.detached(priority: .background) {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            if let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 1, preferredTimescale: 60), actualTime: nil) {
                let uiImage = UIImage(cgImage: cgImage)
                await MainActor.run {
                    self.imageView.image = uiImage
                    self.loader.stopAnimating()
                }
            }
        }
    }
}
