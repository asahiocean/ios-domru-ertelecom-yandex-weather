import UIKit

final class SplashScreenViewController: UIViewController {
    
    // MARK: - Public properties -
    
    var presenter: SplashScreenPresenterInterface!
    
    // MARK: - Private properties -
    
    @IBOutlet private weak var logoDomRuImageView: UIImageView!
    @IBOutlet private weak var loadIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

// MARK: - Extensions -

extension SplashScreenViewController: SplashScreenViewInterface {
    func statusLabel(with message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel?.text = message
            self?.view.layoutIfNeeded()
        }
    }
    
    func setupView() {
        navigationController?.navigationBar.isHidden = true
        presenter?.statusLabelConfig(with: statusLabel)
        presenter?.indicatorConfig(with: loadIndicatorView)
    }
}
