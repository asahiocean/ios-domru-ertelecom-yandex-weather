import Foundation

public extension Date {
    /// HH:mm:ss
    var currentTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self)
    }
}
