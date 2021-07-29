import Foundation

/// The model for the leftmost cell of the collection
struct ZeroSectionModel {
    let wind_speed: String?
    let wind_dir: (name: String, degrees: Double?)
    let pressure_mm: String
    let humidity: String
    
    internal init(ws wind_speed: String?,
                  wd wind_dir: (name: String, degrees: Double?),
                  pmm pressure_mm: String,
                  h humidity: String) {
        self.wind_speed = wind_speed
        self.wind_dir = wind_dir
        self.pressure_mm = pressure_mm
        self.humidity = humidity
    }
}
