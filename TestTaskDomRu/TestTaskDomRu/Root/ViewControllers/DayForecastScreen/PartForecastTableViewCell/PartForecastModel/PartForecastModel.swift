import Foundation
import UIKit.UIImage

protocol PartForecastModelProtocol {
    var name: String { get }
    var temp: PartForecastTemp { get }
    var wind: PartForecastWind { get }
    var humidity: String { get }
    var pressure_mm: String { get }
}

/// The main model for displaying information in a cell with a non-hourly forecast
struct PartForecastModel: PartForecastModelProtocol, Equatable {
    let name: String
    let temp: PartForecastTemp
    let wind: PartForecastWind
    let humidity: String
    let pressure_mm: String
    
    internal init(name: String,
                  temp: PartForecastTemp,
                  wind: PartForecastWind,
                  h humidity: String,
                  pmm pressure_mm: String) {
        self.name = name
        self.temp = temp
        self.wind = wind
        self.humidity = humidity
        self.pressure_mm = pressure_mm
    }
    
    static func == (lhs: PartForecastModel, rhs: PartForecastModel) -> Bool {
        return lhs.name == rhs.name &&
            lhs.temp == rhs.temp &&
            lhs.wind == rhs.wind &&
            lhs.humidity == rhs.humidity &&
            lhs.pressure_mm == rhs.pressure_mm
    }
}

/// Model with temperature data, for cells with non-hourly forecast
struct PartForecastTemp: Equatable {
    let conditionIcon: UIImage
    let temp: String
    let tempFeelslike: String
    
    static func == (lhs: PartForecastTemp, rhs: PartForecastTemp) -> Bool {
        return lhs.conditionIcon == rhs.conditionIcon &&
            lhs.temp == rhs.temp &&
            lhs.tempFeelslike == rhs.tempFeelslike
    }
}

/// A model with wind data, for cells with a non-hourly forecast
struct PartForecastWind: Equatable {
    let wind_speed: String
    let wind_gust: String
    let wind_dir: String
    
    static func == (lhs: PartForecastWind, rhs: PartForecastWind) -> Bool {
        return lhs.wind_speed == rhs.wind_speed &&
            lhs.wind_gust == rhs.wind_gust &&
            lhs.wind_dir == rhs.wind_dir
    }
}
