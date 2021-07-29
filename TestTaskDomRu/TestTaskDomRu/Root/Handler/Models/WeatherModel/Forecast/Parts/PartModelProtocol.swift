import Foundation

protocol PartModelProtocol {
    var source: String? { get }
    var tempMin: Double? { get }
    var tempAvg: Double? { get }
    var tempMax: Double? { get }
    var tempWater: Double? { get }
    var windSpeed: Double? { get }
    var windGust: Double? { get }
    var windDir: String? { get }
    var pressureMm: Double? { get }
    var pressurePa: Double? { get }
    var humidity: Double? { get }
    var soilTemp: Double? { get }
    var soilMoisture: Double? { get }
    var precMm: Double? { get }
    var precProb: Double? { get }
    var precPeriod: Double? { get }
    var cloudness: Double? { get }
    var precType: Double? { get }
    var precStrength: Double? { get }
    var icon: String? { get }
    var condition: String? { get }
    var uvIndex: Double? { get }
    var feelsLike: Double? { get }
    var daytime: String? { get }
    var polar: Bool? { get }
}
