import UIKit

final class DayForecastWireframe: BaseWireframe {
    
    // MARK: - Module setup -
    
    init() {
        let moduleViewController = DayForecastViewController()
        super.init(viewController: moduleViewController)
        
        let interactor = DayForecastInteractor()
        let presenter = DayForecastPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension DayForecastWireframe: DayForecastWireframeInterface {
    
    func forecast(with model: Forecast, date: String, _ completion: @escaping (() -> ())) {
        guard let controller = viewController as? DayForecastViewController else {
            fatalError("Unknown ViewController")
        }
        controller.presenter.config(with: model, date)
        completion()
    }
}
