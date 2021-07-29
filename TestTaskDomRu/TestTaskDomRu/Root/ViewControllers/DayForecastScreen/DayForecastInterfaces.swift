import UIKit

protocol DayForecastWireframeInterface: WireframeInterface {
    func forecast(with forecast: Forecast, date: String, _ completion: @escaping (()->()))
}

protocol DayForecastViewInterface: ViewInterface {
    func titleConfigure(with text: String)
    func tableViewConfigure(with tableView: UITableView)
    func reloadData()
}

protocol DayForecastPresenterInterface: PresenterInterface {
    func viewDidLoad()
    func config(with model: Forecast, _ date: String)
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func cellConfig(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell
    func titleForHeader(in section: Int) -> String?
    func viewForHeader(in section: Int) -> UIView?
    func heightForHeader(in section: Int) -> CGFloat
    func viewForFooter(in section: Int) -> UIView?
}

protocol DayForecastInteractorInterface: InteractorInterface {
    var delegate: DayForecastInteractorDelegate? { get set }
    func partsModelConfigure(with sections: [ForecastSection])
    func hoursModelIsEmpty() -> Bool
    func numberOfSections() -> Int
    func hoursModel(at index: Int, _ completion: @escaping ((HourlyForecastModel) -> ()))
    func forecastModel(with model: Forecast)
    func numberOfRows(in section: Int) -> Int
    func partsModels(in section: Int, _ completion: @escaping (([String:[String:PartForecastModel]]) -> ()))
    func titleForHeader(in section: Int) -> String?
    func viewForHeader(in section: Int) -> UIView?
}
