import Foundation
import UIKit.UIColor

public func Color(_ name: String) -> UIColor {
    if #available(iOS 11.0, *) {
        return UIColor(named: name) ?? .black
    } else {
        switch name {
        case "LogoDomRu":
            return UIColor(hex: "#D40006")
        default:
            print("🎨 Color \(name) NOT FOUND!")
            return .black
        }
    }
}
