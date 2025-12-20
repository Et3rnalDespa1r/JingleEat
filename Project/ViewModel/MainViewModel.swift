import UIKit

class MainViewModel {
    

    private let content = MainContent(
        title: "JingleEat 🎄",
        description: "Получайте вдохновения для праздничного стола вместе с JingleEat!",
        gingerImageName: "ginger",
        garlandImageName: "garland"
    )
    
    var titleText: String { content.title }
    var descriptionText: String { content.description }
    var gingerImage: UIImage? { UIImage(named: content.gingerImageName) }
    var garlandImage: UIImage? { UIImage(named: content.garlandImageName) }
    
    let titleColor = UIColor(red: 0.35, green: 0.18, blue: 0.05, alpha: 1.0)
    let descriptionColor = UIColor(red: 0.55, green: 0.35, blue: 0.25, alpha: 1.0)
    
    func registerTapped() {
        print("Нажали регистрацию — логика во ViewModel")
    }
    
    func loginTapped() {
        print("Нажали вход — логика во ViewModel")
    }
}
