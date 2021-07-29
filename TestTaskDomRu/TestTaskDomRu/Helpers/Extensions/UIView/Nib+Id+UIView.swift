import UIKit.UIView

public extension UIView {
    static var id: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: id, bundle: nil) }
}
