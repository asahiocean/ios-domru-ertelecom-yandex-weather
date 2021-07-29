import Foundation
import UIKit.UIColor

extension UIColor {
    /// Converting HEX-color to RGBA
    convenience init(hex: String, a alpha: CGFloat = 1.0) {
        let hex: String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scan: Scanner = .init(string: hex)
        if hex.hasPrefix("#") { scan.scanLocation = 1 }
        var color: UInt32 = 0
        scan.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask,
            g = Int(color >> 8) & mask,
            b = Int(color) & mask
        
        func convert(_ v: Int) -> CGFloat { CGFloat(v) / 255.0 }
        let red = convert(r), green = convert(g), blue  = convert(b)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
