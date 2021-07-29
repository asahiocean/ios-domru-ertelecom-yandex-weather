import UIKit

final class DayForecastPresenter {
    
    // MARK: - Private properties -
    
    private unowned let view: DayForecastViewInterface
    private let interactor: DayForecastInteractorInterface
    private let wireframe: DayForecastWireframeInterface
    
    private var forecastDate: String = ""
    
    internal typealias Section = ForecastSection
    
    /// Sections for displaying non-hourly forecast information
    private let sections: [Section] = [
        Section("Температура", num: 0),
        Section("Ветер", num: 1),
        Section("Влажность", num: 2),
        Section("Давление", num: 3)
    ]
    
    /// Method for setting the controller name
    private func titleConfigure() {
        view.titleConfigure(with: "Прогноз на \(forecastDate)")
    }
    
    /// Function for creating and first configuring UITableView for hourly forecast information
    private func tableViewConfigure() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(HourCell.nib, forCellReuseIdentifier: HourCell.reuseId)
        tableView.register(PartCell.nib, forCellReuseIdentifier: PartCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        view.tableViewConfigure(with: tableView)
    }
    
    // MARK: - Lifecycle -
    
    fileprivate func commonInit() {
        interactor.delegate = self
        interactor.partsModelConfigure(with: sections)
    }
    
    init(view: DayForecastViewInterface, interactor: DayForecastInteractorInterface, wireframe: DayForecastWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.commonInit()
    }
}

// MARK: - Extensions -

extension DayForecastPresenter: DayForecastPresenterInterface {
    
    // MARK: - Header -
    
    func heightForHeader(in section: Int) -> CGFloat {
        if interactor.hoursModelIsEmpty() {
            return 44
        } else {
            return 0
        }
    }
    
    func titleForHeader(in section: Int) -> String? {
        return interactor.titleForHeader(in: section)
    }
    
    func viewForHeader(in section: Int) -> UIView? {
        return interactor.viewForHeader(in: section)
    }
    
    // MARK: - Cells -
    
    func numberOfSections() -> Int {
        return interactor.numberOfSections()
    }
    
    func numberOfRows(in section: Int) -> Int {
        return interactor.numberOfRows(in: section)
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if interactor.hoursModelIsEmpty() {
            // Cell at non-hourly forecast information
            // Unfixed height
            return UITableView.automaticDimension
        } else {
            return 75
        }
    }
    
    /// Function for configuring the cell content
    func cellConfig(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        func dequeueReusableCell<T:UITableViewCell>(id: String = String(describing: T.self), _ index: IndexPath) -> T {
            return tableView.dequeueReusableCell(withIdentifier: id, for: index) as! T
        }
        switch interactor.hoursModelIsEmpty() {
        case true:
            let cell: PartCell = dequeueReusableCell(indexPath)
            interactor.partsModels(in: indexPath.section, {
                cell.config(dict: $0)
            })
            return cell
        case false:
            let cell: HourCell = dequeueReusableCell(indexPath)
            interactor.hoursModel(at: indexPath.row, {
                cell.forecast(with: $0)
            })
            return cell
        }
    }
    
    // MARK: - Footer -
    
    func viewForFooter(in section: Int) -> UIView? {
        return .init()
    }
    
    // MARK: - Lifecycle
    
    func viewDidLoad() {
        tableViewConfigure()
        titleConfigure()
    }
    
    func config(with model: Forecast, _ date: String) {
        self.forecastDate = date
        interactor.forecastModel(with: model)
    }
}

extension DayForecastPresenter: DayForecastInteractorDelegate {
    func updateNotify() {
        view.reloadData()
    }
}

struct ForecastSection: Equatable {
    let title: String
    let section: Int
    init(_ title: String, num section: Int) {
        self.title = title
        self.section = section
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title && lhs.section == rhs.section
    }
}
