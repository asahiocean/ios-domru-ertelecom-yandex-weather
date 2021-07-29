import UIKit

final class SplashScreenWireframe: BaseWireframe {
    
    private let forecastWireframe = ForecastWireframe()
    
    // MARK: - Module setup -
    
    init() {
        let moduleViewController = SplashScreenViewController()
        super.init(viewController: moduleViewController)
        
        let interactor = SplashScreenInteractor()
        let presenter = SplashScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension SplashScreenWireframe: SplashScreenWireframeInterface {
    func presentForecastScreen() {
        DispatchQueue.main.async { [self] in
            guard let nav = navigationController else { fatalError() }
            let t = CATransition()
            t.timingFunction = .init(name: .easeInEaseOut)
            t.isRemovedOnCompletion = true
            t.subtype = .none
            t.type = .fade
            t.duration = 0.5
            t.fillMode = .removed
            CATransaction.begin()
            nav.view.window!.layer.add(t, forKey: kCATransition)
            nav.view.semanticContentAttribute = .unspecified
            CATransaction.commit()
            nav.setRootWireframe(forecastWireframe, animated: false)
            // nav.pushWireframe(forecastWireframe, animated: false)
        }
    }
}
