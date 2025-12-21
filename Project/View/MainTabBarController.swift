import UIKit

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 90
        return sizeThatFits
    }
}

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupTabs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let horizontalPadding: CGFloat = 20
        let bottomPadding: CGFloat = 35
        let barHeight: CGFloat = 90
        let width = view.bounds.width - (horizontalPadding * 2)
        
        tabBar.frame = CGRect(
            x: horizontalPadding,
            y: view.bounds.height - barHeight - bottomPadding,
            width: width,
            height: barHeight
        )
        
        tabBar.layer.cornerRadius = barHeight / 2
        tabBar.layer.masksToBounds = false
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 10)
        tabBar.layer.shadowOpacity = 0.15
        tabBar.layer.shadowRadius = 15
    }
    
    private func setupCustomTabBar() {
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
    }

    private func setupTabs() {
        // Проверь имена в Assets:
        let nav1 = createNav(with: HomeViewController(),
                             title: "Лента",
                             inactiveName: "tap_home",
                             activeName: "tap_home_green")
        
        let nav2 = createNav(with: ChatViewController(),
                             title: "Гигачат",
                             inactiveName: "tap_chat",
                             activeName: "tap_chat_green")
        
        let nav3 = createNav(with: ProfileViewController(),
                             title: "Профиль",
                             inactiveName: "tap_profile",
                             activeName: "tap_profile_green")
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
    
    private func createNav(with rootVC: UIViewController, title: String, inactiveName: String, activeName: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        

        func makeTabImage(named: String) -> UIImage? {
            guard let image = UIImage(named: named) else { return nil }
            let size = CGSize(width: 50, height: 50)
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: size))
            }.withRenderingMode(.alwaysOriginal)
        }
        
        nav.tabBarItem.image = makeTabImage(named: inactiveName)
        nav.tabBarItem.selectedImage = makeTabImage(named: activeName)
        nav.tabBarItem.title = title
        nav.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        nav.tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let winterHvoyn = UIColor(red: 0.11, green: 0.38, blue: 0.19, alpha: 1.0)
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray,
            .font: font
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: winterHvoyn,
            .font: font
        ]
        
        nav.tabBarItem.standardAppearance = appearance
        nav.tabBarItem.scrollEdgeAppearance = appearance
        
        nav.navigationBar.prefersLargeTitles = true
        rootVC.navigationItem.title = title
        
        return nav
    }
}
