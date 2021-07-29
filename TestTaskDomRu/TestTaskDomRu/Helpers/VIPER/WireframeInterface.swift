import Foundation

protocol WireframeInterface: AnyObject {
    func popFromNavigationController(animated: Bool)
    func dismiss(animated: Bool)
}
