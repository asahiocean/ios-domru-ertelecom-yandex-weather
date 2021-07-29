import Foundation
import UIKit.UIImage

protocol HourlyForecastModelProtocol {
    var time: String { get }
    var temp: String { get }
    var conditionImage: UIImage { get }
    var windSpeed: String { get }
    var humidity: String { get }
    var pressure: String { get }
}

/// A model for displaying hourly forecast information
struct HourlyForecastModel: HourlyForecastModelProtocol {
    
    let time: String
    let temp: String
    let conditionImage: UIImage
    let windSpeed: String
    let humidity: String
    let pressure: String
    
    internal init(time: String,
                  temp: String,
                  image conditionImage: UIImage,
                  ws windSpeed: String,
                  h humidity: String,
                  pmm pressure: String) {
        self.time = time
        self.temp = temp
        self.conditionImage = conditionImage
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.pressure = pressure
    }
}
