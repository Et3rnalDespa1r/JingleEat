import UIKit
import Combine
import AVKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private let searchButton = UIButton(type: .system)
    
    private let viewModel = HomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        VideoPlayerManager.shared.pauseVideo()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        headerView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(red: 0.05, green: 0.12, blue: 0.25, alpha: 1.0) : UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        titleLabel.text = "JingleEat"
        titleLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        titleLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : AppTheme.Colors.chocolate
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        addButton.setImage(UIImage(systemName: "plus", withConfiguration: buttonConfig), for: .normal)
        addButton.tintColor = titleLabel.textColor
        addButton.backgroundColor = UIColor.white.withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.2 : 0.5)
        addButton.layer.cornerRadius = 22
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        headerView.addSubview(addButton)
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: buttonConfig), for: .normal)
        searchButton.tintColor = titleLabel.textColor
        searchButton.backgroundColor = UIColor.white.withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.2 : 0.5)
        searchButton.layer.cornerRadius = 22
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(searchButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isPagingEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.register(TikTokVideoCell.self, forCellReuseIdentifier: "TikTokVideoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 110),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
            
            addButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            addButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            
            searchButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            searchButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 44),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$recipes.receive(on: RunLoop.main).sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    @objc private func addTapped() {
        let vc = AddVideoViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) { [weak self] in
            self?.viewModel.recipes = StorageService.shared.loadRecipes()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TikTokVideoCell", for: indexPath) as! TikTokVideoCell
        cell.configure(with: viewModel.recipes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    
        
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.y / scrollView.bounds.height)
        if index >= 0 && index < viewModel.recipes.count {
            viewModel.handleScrollChange(newID: viewModel.recipes[index].id)
        }
    }
}
