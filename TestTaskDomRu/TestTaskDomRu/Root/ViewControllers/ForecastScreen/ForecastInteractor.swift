import Foundation
import UIKit.UIImage
import FirebaseAnalytics

protocol ForecastInteractorDelegate: AnyObject {
    func updateNotify()
}

final class ForecastInteractor: StorageModelDelegate {
    
    weak var delegate: ForecastInteractorDelegate?
    
    private let updater = Updater.shared
    private let storage = Storage.shared
    private let facade = Facade.shared
    
    private var cachedModel: WeatherModel?
    private var hourlyForecast: [Hour]?
    private var forecastsModels: [TableViewCellModel] = []
    
    private var hourTs: Int = 0
    
    private var zeroSectionModel: ZeroSectionModel?
    
    init() {
        storage.delegate = self
        hourTs = facade.hourStartTimestamp()
    }
}

extension ForecastInteractor {
    
    private func forecastsHandler(with forecasts: [Forecast]?) {
        guard let forecasts = forecasts else { return }
        func hourlyHandler(with forecasts: [Forecast]) {
            autoreleasepool {
                let hoursArrays = forecasts.compactMap({$0.hours})
                let hours = hoursArrays.flatMap({$0})
                let ts = Double(hourTs)
                let futureHours = hours.filter { $0.hourTs! >= ts }
                self.hourlyForecast = futureHours
            }
        }
        func forecastsHandler(with forecasts: [Forecast]) {
            autoreleasepool {
                guard forecastsModels.isEmpty else { return }
                let cal = NSCalendar.current as NSCalendar
                let today = Date()
                let currentDay = cal.component(.day, from: today)
                var futureComp = DateComponents()
                futureComp.day = 1
                let dateFuture = cal.date(byAdding: futureComp, to: today)!
                let nextDay = cal.component(.day, from: dateFuture)
                
                for item in forecasts {
                    let ddMM = facade.dateConverter(item.date!)
                    var wd: String = "" // week day
                    switch Int(item.date!.suffix(2))! {
                    case currentDay:
                        wd = "сегодня"
                    case nextDay:
                        wd = "завтра"
                    default:
                        wd = facade.dateTemplate(item.date!, "EEEE")
                    }
                    let weekDay = wd.capitalizingFirstLetter()
                    
                    let dayShort = (item.parts?.dayShort)!
                    
                    let image = Image(dayShort.icon!) ?? Image("ovc")!
                    let t1 = Int(dayShort.temp!), t2 = Int(dayShort.tempMin!)
                    var t1str = String(t1), t2str = String(t2)
                    facade.tempOperators(t1, &t1str)
                    facade.tempOperators(t2, &t2str)
                    
                    forecastsModels.append(.init(ddMM: ddMM,
                                                 wd: weekDay,
                                                 icon: image,
                                                 tmax: t1str,
                                                 tmin: t2str))
                }
            }
        }
        hourlyHandler(with: forecasts)
        forecastsHandler(with: forecasts)
    }
    
    func updatedModel(with model: WeatherModel) {
        self.cachedModel = model
        forecastsHandler(with: model.forecasts)
        hourTs = facade.hourStartTimestamp()
        delegate?.updateNotify()
    }
}

// MARK: - Extensions -

extension ForecastInteractor: ForecastInteractorInterface {
    
    func floatingViewClicked() {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                    AnalyticsParameterItemID: "floatingViewClicked",
                    AnalyticsParameterItemName: "\(#function)",
                    AnalyticsParameterItemCategory: "ads"
                ])
                print("БИНГО!", #function)
            }
        }
    }
    
    func localityName(_ completion: @escaping (String) -> ()) {
        let model = (cachedModel ?? storage.model)
        if let geo = model?.geoObject,
           let name = (geo.locality?.name ?? geo.province?.name) {
            completion(name)
        } else {
            completion("Погода")
        }
    }
    
    // MARK: - Temperature: Header
    
    func factTemp(_ completion: @escaping ((String)->())) {
        let model = (cachedModel ?? storage.model)
        if let temp = model?.fact?.temp {
            var text = String(Int(temp))
            facade.tempOperators(Int(temp), &text)
            completion(text)
        } else {
            completion("--º")
        }
    }
    
    func factCondition(_ completion: @escaping ((String) -> ())) {
        let model = (cachedModel ?? storage.model)
        if let value = model?.fact?.condition {
            facade.factCondition(with: value, completion)
        } else {
            completion("Нет данных")
        }
    }
    
    func factFeelsLike(_ completion: @escaping ((String) -> ())) {
        let model = (cachedModel ?? storage.model)
        if let temp = model?.fact?.feelsLike {
            facade.factFeelsLike(with: temp, completion)
        } else {
            completion("Упс, что-то не так ( ͡° ͜ʖ ͡°)")
        }
    }
    
    // MARK: - CollectionView: Forecast -
    
    func zeroSection(_ completion: @escaping ((ZeroSectionModel) -> ())) {
        if let model = zeroSectionModel {
            completion(model)
        } else {
            let model = (cachedModel ?? storage.model)
            if let fact = model?.fact {
                facade.zeroSection(fact, &zeroSectionModel, completion)
            } else {
                fatalError("Where to get the data?!")
            }
        }
    }
    
    func oneSection(at indexPath: IndexPath, _ completion: @escaping ((OneSectionModel) -> ())) {
        if let model = hourlyForecast?[indexPath.row] {
            facade.hourModel(with: model, completion)
        }
    }
    
    // MARK: - TableView -
    
    func forecastsCount() -> Int {
        return forecastsModels.count
    }
    
    func tenDaysForecast(for index: Int) -> TableViewCellModel? {
        guard forecastsModels.indices.contains(index) else {
            return nil
        }
        return forecastsModels[index]
    }
    
    func didSelectRow(at indexPath: IndexPath, _ completion: @escaping ((Forecast, String) -> ())) {
        let index = indexPath.row
        DispatchQueue.global(qos: .background).async { [self] in
            let dateOfMonth = forecastsModels[index].dateOfMonth
            autoreleasepool {
                Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
                    AnalyticsParameterItemID: "dateOfMonth",
                    AnalyticsParameterItemName: dateOfMonth,
                    AnalyticsParameterItemCategory: "didSelectRow"
                ])
            }
        }
        let model = (cachedModel ?? storage.model)
        guard let forecast = model?.forecasts?[index] else {
            fatalError("Forecast not found!")
        }
        let date = forecastsModels[index].dateOfMonth
        completion(forecast, date)
    }
}
