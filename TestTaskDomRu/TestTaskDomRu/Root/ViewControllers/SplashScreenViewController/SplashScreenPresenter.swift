import UIKit

protocol StatusLabelDelegate: AnyObject {
    func status(with message: String)
    func completed(_ status: Bool)
}

final class SplashScreenPresenter: StatusLabelDelegate {
    
    func status(with message: String) {
        view.statusLabel(with: message)
    }
    
    func completed(_ status: Bool) {
        switch status {
        case true:
            wireframe.presentForecastScreen()
        default: break
        }
    }
    
    // MARK: - Private properties -
    
    private unowned let view: SplashScreenViewInterface
    private let interactor: SplashScreenInteractorInterface
    private let wireframe: SplashScreenWireframeInterface
    
    func statusTimerStart() {
        interactor.delegate = self
    }
    
    // MARK: - Lifecycle -
    
    init(view: SplashScreenViewInterface, interactor: SplashScreenInteractorInterface, wireframe: SplashScreenWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        statusTimerStart()
    }
}

// MARK: - Extensions -

extension SplashScreenPresenter: SplashScreenPresenterInterface {
    
    func viewDidLoad() {
        view.setupView()
        interactor.session({ (completed) in })
    }
    
    func statusLabelConfig(with label: UILabel?) {
        guard let label = label else { return }
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize: 20, weight: .light)
    }
    
    func indicatorConfig(with indicator: UIActivityIndicatorView?) {
        guard let indicator = indicator else { return }
        indicator.isHidden = false
        indicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            indicator.style = .medium
        } else {
            indicator.transform = .init(scaleX: 1.25, y: 1.25)
        }
        indicator.startAnimating()
    }
}
