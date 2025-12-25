import UIKit
import SwiftUI

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
        setupAppearance()
    }
    
    private func setupCustomTabBar() {
        let customTabBar = CustomTabBar()
        self.setValue(customTabBar, forKey: "tabBar")
    }
    
    private func setupTabs() {
        let swiftUIHome = HomeViewSwiftUI()
        let hostingController = UIHostingController(rootView: swiftUIHome)
        
        let nav1 = createNav(with: hostingController,
                             title: "Лента",
                             inactiveName: "tap_home",
                             activeName: "tap_home_green")
        
        let chatView = ChatView()
        let chatHostingController = UIHostingController(rootView: chatView)
        chatHostingController.view.backgroundColor = .clear
        let nav2 = createNav(with: chatHostingController,
                             title: "Гигачат",
                             inactiveName: "tap_chat",
                             activeName: "tap_chat_green")
        nav2.isNavigationBarHidden = true
        
        let profileView = ProfileView()
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.view.backgroundColor = .clear
        
        let nav3 = createNav(with: profileVC,
                             title: "Профиль",
                             inactiveName: "tap_profile",
                             activeName: "tap_profile_green")
        nav3.isNavigationBarHidden = true
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
    
    private func createNav(with rootVC: UIViewController, title: String, inactiveName: String, activeName: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        
        func makeIcon(named: String) -> UIImage? {
            guard let image = UIImage(named: named) else { return nil }
            let targetSize = CGSize(width: 50, height: 50)
            
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: targetSize))
            }.withRenderingMode(.alwaysOriginal)
        }
        
        nav.tabBarItem.image = makeIcon(named: inactiveName)
        nav.tabBarItem.selectedImage = makeIcon(named: activeName)
        nav.tabBarItem.title = title
        
        nav.navigationBar.prefersLargeTitles = true
        rootVC.navigationItem.title = title
        
        return nav
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        let font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: font,
            .foregroundColor: UIColor.gray
        ]
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .gray
    }
}
