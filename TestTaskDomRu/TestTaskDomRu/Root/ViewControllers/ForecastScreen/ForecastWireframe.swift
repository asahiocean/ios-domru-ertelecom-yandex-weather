import UIKit

final class ForecastWireframe: BaseWireframe {
    
    // MARK: - Private properties -
    
    private let storyboard = UIStoryboard(name: "Forecast", bundle: nil)
    
    // MARK: - Module setup -
    
    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: ForecastViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = ForecastInteractor()
        let presenter = ForecastPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
    
}

// MARK: - Extensions -

extension ForecastWireframe: ForecastWireframeInterface {
    func forecast(with model: Forecast, date: String) {
        let wireframe = DayForecastWireframe()
        wireframe.forecast(with: model, date: date, { [self] in
            if let nav = navigationController {
                nav.pushWireframe(wireframe)
            } else {
                viewController.presentWireframe(wireframe)
            }
        })
        
    }
}
