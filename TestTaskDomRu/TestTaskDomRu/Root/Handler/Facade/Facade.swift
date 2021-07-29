import Foundation

class Facade {
    
    public static let shared = Facade()
    
    /// Getting current hour
    lazy var currentHour: Int = {
        return cal.component(.hour, from: Date())
    }()
    lazy var currentDay: Int = {
        return cal.component(.day, from: Date())
    }()
    lazy var currentMonth: Int = {
        return cal.component(.month, from: Date())
    }()
    
    lazy var tomorrowStartTs: Int = {
        let nextDay = cal.date(byAdding: .day, value: 1, to: Date())
        let startNextDay = cal.startOfDay(for: nextDay!)
        return Int(startNextDay.timeIntervalSince1970)
    }()
    
    private let cal = Calendar.current
    
    private(set) var currentHourStartTS: Int = 0
    
    func hourStartTimestamp() -> Int {
        // Getting start time of the current day
        let startOfDay = cal.startOfDay(for: Date())
        // Conversion to unix format
        let ts = Int(startOfDay.timeIntervalSince1970)
        let result = (ts + ((currentHour * 60) * 60))
        self.currentHourStartTS = result
        return result
    }
    
    // MARK: - Header: Fact temperature -
    
    func factFeelsLike(with value: Double, _ completion: @escaping ((String) -> ())) {
        let temp = Int(value)
        var text = String(temp)
        tempOperators(temp, &text)
        let result = "Ощущается как \(text)"
        completion(result)
    }
    
    func tempOperators(_ temp: Int, _ text: inout String) {
        switch temp >= 1 {
        case true:
            text.insert("+", at: text.startIndex)
        case false where temp <= -1:
            text.insert("-", at: text.startIndex)
        default:
            break
        }
        text.insert("º", at: text.endIndex)
    }
    
    public func factCondition(with condition: Condition, _ completion: @escaping ((String) -> ())) {
        switch condition {
        case .clear:
            completion("Ясно")
        case .partlyCloudy:
            completion("Малооблачно")
        case .cloudy:
            completion("Облачно с прояснениями")
        case .overcast:
            completion("Пасмурно")
        case .drizzle:
            completion("Морось")
        case .lightRain:
            completion("Небольшой дождь")
        case .rain:
            completion("Дождь")
        case .moderateRain:
            completion("Умеренно сильный дождь")
        case .heavyRain:
            completion("Сильный дождь")
        case .continuousHeavyRain:
            completion("Длительный сильный дождь")
        case .showers:
            completion("Ливень")
        case .wetSnow:
            completion("Дождь со снегом")
        case .lightSnow:
            completion("Небольшой снег")
        case .snow:
            completion("Снег")
        case .snowShowers:
            completion("Снегопад")
        case .hail:
            completion("Град")
        case .thunderstorm:
            completion("Гроза")
        case .thunderstormWithRain:
            completion("Дождь с грозой")
        case .thunderstormWithHail:
            completion("Гроза с градом")
        }
    }
    
    // MARK: - Zero Section -
    
    public func zeroSection(_ fact: Fact, _ oldModel: inout ZeroSectionModel?, _ completion: @escaping ((ZeroSectionModel)->())) {
        let windSpeed = windSpeed(with: fact.windSpeed)
        let windDir = windDir(for: fact.windDir)
        let pressure = pressureMm(with: fact.pressureMm)
        let humidity = humidity(with: fact.humidity)
        let model = ZeroSectionModel(ws: windSpeed,
                                     wd: windDir,
                                     pmm: pressure,
                                     h: humidity)
        oldModel = model
        completion(model)
    }
    
    private func windSpeed(with value: Double?) -> String? {
        let speed = value.map({Int($0)}) ?? 0
        return speed != 0 ? "\(speed) м/с" : nil
    }
    
    func windDir(for windDir: WindDir?) -> (name: String, degrees: Double?) {
        //http://snowfence.umn.edu/Components/winddirectionanddegrees.htm
        /*
         N -> 348.75º - 11.25º
         NNE -> 11.25º - 33.75º
         NE –> 33.75º - 56.25º
         ENE –> 56.25º - 78.75º
         E –> 78.75º - 101.25º
         ESE –> 101.25º - 123.75º
         SE –> 123.75º - 146.25º
         SSE –> 146.25º - 168.75º
         S –> 168.75º - 191.25º
         SSW –> 191.25º - 213.75º
         SW –> 213.75º - 236.25º
         WSW –> 236.25º - 258.75º
         W –> 258.75º - 281.25º
         WNW –> 281.25º - 303.75º
         NW –> 303.75º - 326.25º
         NNW –> 326.25º - 348.75º
         */
        
        func values(for direction: WindDir) -> (direction: String, degrees: Double?) {
            switch direction {
            case .nw: return ("СЗ", [303.75,326.25].average)
            case .n: return ("С", [348.75,11.25].average)
            case .ne: return ("СВ", [33.75,56.25].average)
            case .e: return ("В", [78.75,101.25].average)
            case .se: return ("ЮВ", [123.75,146.25].average)
            case .s: return ("Ю", [168.75,191.25].average)
            case .sw: return ("ЮЗ", [213.75,236.25].average)
            case .w: return ("З", [258.75,281.25].average)
            case .c: return ("штиль", nil)
            }
        }
        if let direction = windDir {
            let value = values(for: direction)
            return (value.direction, value.degrees)
        } else {
            return ("н/д", nil)
        }
    }
    
    func pressureMm(with value: Double?) -> String {
        var pressure = value.map{ String(Int($0)) } ?? "--"
        pressure += " мм рт.ст."
        return pressure
    }
    
    func humidity(with value: Double?) -> String {
        var humidity = value.map{ String(Int($0)) } ?? "--"
        humidity += " %"
        return humidity
    }
    
    func hourConvert(_ model: Hour, _ time: inout String, onlyNum: Bool = false) {
        let hour = Int(model.hour ?? "0")!
        switch hour == currentHour {
        case true where onlyNum == false:
            time = "Сейчас"
        default:
            if hour < 10 { insertZero(&time) }
            time += ":00"
            if model.hourTs == Double(tomorrowStartTs) {
                let day = currentDay
                var dayStr = String(day)
                if day < 10 { insertZero(&dayStr) }
                let month = currentMonth
                var monthStr = String(month)
                if month < 10 { insertZero(&monthStr) }
                time += "\n\(dayStr).\(monthStr)"
            }
        }
        func insertZero(_ string: inout String) {
            string.insert("0", at: string.startIndex)
        }
    }
    
    func hourModel(with model: Hour, _ completion: @escaping ((OneSectionModel) -> ())) {
        var time = (model.hour)!
        hourConvert(model, &time)
        let image = Image(model.icon!) ?? Image("ovc")!
        var temp = Int(model.temp!), tempStr = String(temp)
        self.tempOperators(temp, &tempStr)
        completion(.init(time: time, image: image, temp: tempStr))
    }
    
    func dateTemplate(_ strDate: String, _ template: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: strDate) else {
            fatalError("Incorrect format date!")
        }
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate(template)
        format.locale = Locale(identifier: "ru_RU")
        let result = format.string(from: date)
        return result
    }
    
    func dateConverter(_ strDate: String) -> String {
        var month = dateTemplate(strDate, "MMMM"), day = strDate.suffix(2)
        // Transformation: 09 -> 9
        if day[day.startIndex] == "0" {
            day = day.dropFirst()
        }
        month = month.replacingOccurrences(of: "ь", with: "я")
        return "\(day) \(month)"
    }
    
    func partForecast(_ title: String, _ model: PartModelProtocol, _ completion: @escaping ((String,PartForecastModel)->())) {
        
        let image = Image(model.icon!) ?? Image("ovc")!
        let tempAvg = Int(model.tempAvg!)
        var tempAvgStr = String(tempAvg)
        tempOperators(tempAvg, &tempAvgStr)
        
        let tempFeelsLike = Int(model.feelsLike!)
        var tempFeelsLikeStr = String(tempFeelsLike)
        tempOperators(tempFeelsLike, &tempFeelsLikeStr)
        
        let temp = PartForecastTemp(conditionIcon: image,
                                    temp: tempAvgStr,
                                    tempFeelslike: tempFeelsLikeStr)
        
        let windSpeed = String(Int(model.windSpeed!))
        let windGust = String(Int(model.windGust!))
        let windDir = windDir(for: WindDir(rawValue: model.windDir!)).name
        
        let wind = PartForecastWind(wind_speed: windSpeed,
                                    wind_gust: windGust,
                                    wind_dir: windDir)
        
        let humidity = humidity(with: model.humidity)
        let pressure = pressureMm(with: model.pressureMm)
        
        let model = PartForecastModel(name: title,
                                      temp: temp,
                                      wind: wind,
                                      h: humidity,
                                      pmm: pressure)
        completion(title, model)
    }
}
