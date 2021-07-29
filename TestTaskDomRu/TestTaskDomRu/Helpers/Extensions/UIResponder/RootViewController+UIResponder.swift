import Foundation
import UIKit.UIResponder

extension UIResponder {
    /// Initializes the start screen and set it to **root for UIWindow**
    public static func rootViewController(for window: UIWindow?) {
        guard let window = window else { fatalError() }
        // MARK: Specify which controller to load
        let wireframe = SplashScreenWireframe()
        let root = MainNavigationController()
        root.setRootWireframe(wireframe)
        window.rootViewController = root
        window.makeKeyAndVisible()
    }
}
