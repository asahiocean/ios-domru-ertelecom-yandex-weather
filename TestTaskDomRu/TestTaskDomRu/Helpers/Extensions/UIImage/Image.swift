import UIKit.UIImage

/// For convenience, when choosing an image from the editor to the Xcode
public func Image(_ name: String) -> UIImage? {
    if #available(iOS 13.0, *) {
        return UIImage(named: name) ?? UIImage(systemName: name)
    } else {
        return UIImage(named: name)
    }
}
