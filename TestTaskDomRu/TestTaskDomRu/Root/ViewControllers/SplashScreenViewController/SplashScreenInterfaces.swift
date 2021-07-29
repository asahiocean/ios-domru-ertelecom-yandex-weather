import UIKit

protocol SplashScreenWireframeInterface: WireframeInterface {
    func presentForecastScreen()
}

protocol SplashScreenViewInterface: ViewInterface {
    func setupView()
    func statusLabel(with message: String)
}

protocol SplashScreenPresenterInterface: PresenterInterface {
    func statusLabelConfig(with label: UILabel?)
    func indicatorConfig(with indicator: UIActivityIndicatorView?)
}

protocol SplashScreenInteractorInterface: InteractorInterface {
    var delegate: StatusLabelDelegate? { get set }
    func session(_ completion: @escaping ((Bool)->()))
}
