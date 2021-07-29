import Foundation
import UIKit.UIImage

protocol DayForecastInteractorDelegate: AnyObject {
    func updateNotify()
}

final class DayForecastInteractor {
    
    weak var delegate: DayForecastInteractorDelegate?
    
    private let facade = Facade.shared
    
    private var model: Forecast!
    
    private var hoursModel: [HourlyForecastModel] = []
    private var sections = Stack<[String:[String:PartForecastModel]]>()
    
    fileprivate struct Stack<T: Equatable> {
        fileprivate var array = [T]()
        var count: Int { array.count }
        mutating func push(_ item: T) { array.append(item) }
        var indices: Range<Int> { array.indices }
        subscript(_ index: Int) -> T {
            get { return array[index] }
            set { array[index] = newValue }
        }
    }
    
    // MARK: - Measure Units -
    
    private var windSpeedMeasureUnit: String { return "м/с" }
    private var pressureMeasureUnit: String { return "мм" }
    
    private func tempAverage(t1: Double?, t2: Double?) -> String {
        let t1 = Int(t1!), t2 = Int(t2!)
        let total = Int((t1 + t2) / 2)
        var temp = String(total)
        facade.tempOperators(total, &temp)
        return temp
    }
    
    private func timeConverter(from hour: Hour) -> String {
        var hourStr = (hour.hour)!
        let cond = Int(hour.hourTs!) > facade.currentHourStartTS
        facade.hourConvert(hour, &hourStr, onlyNum: cond)
        return hourStr
    }
    
    private func windSpeed(speed: Double?, gust: Double?) -> String {
        let speed = Int(speed!), gust = Int(gust!)
        let result = "\(speed)-\(gust) \(windSpeedMeasureUnit)"
        return result
    }
    
    private func humidity(with humidity: Double?) -> String {
        return "\(Int(humidity!))" + "%"
    }
    
    private func pressure(with pressure: Double?) -> String {
        return "\(Int(pressure!)) \(pressureMeasureUnit)"
    }
    
    private func hourModel(with model: [Hour]?) {
        guard let hours = model else { return }
        for hour in hours {
            autoreleasepool {
                let tempRange = tempAverage(t1: hour.temp, t2: hour.feelsLike)
                let time = timeConverter(from: hour)
                let image = Image(hour.icon!) ?? Image("ovc")!
                let windSpeed = windSpeed(speed: hour.windSpeed, gust: hour.windGust)
                let humidity = humidity(with: hour.humidity)
                let pressure = pressure(with: hour.pressureMm)
                self.hoursModel.append(.init(time: time,
                                             temp: tempRange,
                                             image: image,
                                             ws: windSpeed,
                                             h: humidity,
                                             pmm: pressure))
                if hoursModel.count == hours.count {
                    self.delegate?.updateNotify()
                }
            }
        }
    }
    
    private func partsModel(with model: Parts?) {
        guard let model = model else { return }
        struct ModelOfDay {
            let title: String
            let model: PartModelProtocol
            init(_ title: String, _ model: PartModelProtocol) {
                self.title = title
                self.model = model
            }
        }
        
        var partModels: [ModelOfDay] = []
        partModels.append(.init("Утром", model.morning!))
        partModels.append(.init("Днём", model.day!))
        partModels.append(.init("Вечером", model.evening!))
        partModels.append(.init("Ночью", model.night!))
        
        for n in sections.indices {
            autoreleasepool {
                let name = sections[n].keys.first! // section name
                for item in partModels {
                    facade.partForecast(item.title,item.model, {
                        self.sections[n][name]?.updateValue($1, forKey: $0)
                    })
                }
            }
        }
    }
    
    init() {
        
    }
}

// MARK: - Extensions -

extension DayForecastInteractor: DayForecastInteractorInterface {
    
    func titleForHeader(in section: Int) -> String? {
        switch hoursModelIsEmpty() {
        case true:
            return sections[section].keys.first
        case false:
            return nil
        }
    }
    
    func viewForHeader(in section: Int) -> UIView? {
        return nil
    }
    
    func partsModelConfigure(with model: [ForecastSection]) {
        model.forEach{ sections.push([$0.title:[:]]) }
    }
    
    func numberOfSections() -> Int {
        switch hoursModelIsEmpty() {
        case true:
            return sections.count
        case false:
            return 1
        }
    }
    
    func partsModels(in section: Int, _ completion: @escaping (([String : [String : PartForecastModel]]) -> ())) {
        let item = sections[section]
        completion(item)
    }
    
    func hoursModel(at index: Int, _ completion: @escaping ((HourlyForecastModel) -> ())) {
        guard hoursModel.indices.contains(index) else { return }
        let model = hoursModel[index]
        completion(model)
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch hoursModelIsEmpty() {
        case true:
            return 1
        default:
            return hoursModel.count
        }
    }
    
    func hoursModelIsEmpty() -> Bool {
        return hoursModel.isEmpty
    }
    
    func forecastModel(with forecast: Forecast) {
        self.model = forecast
        hourModel(with: forecast.hours)
        partsModel(with: forecast.parts)
    }
}
