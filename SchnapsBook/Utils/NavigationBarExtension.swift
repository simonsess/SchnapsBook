import UIKit

extension UINavigationBar {
    static func setCustomTitleColor(_ color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: color]
        appearance.titleTextAttributes = [.foregroundColor: color]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
}
