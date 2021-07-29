import Foundation

extension Int {
    /// Unix-время (Unix time)
    public static var timeSince1970: Int = Int(Date().timeIntervalSince1970)
}
