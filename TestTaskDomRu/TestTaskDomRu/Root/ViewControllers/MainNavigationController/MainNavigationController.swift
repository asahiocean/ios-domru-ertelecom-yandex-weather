import UIKit
import FirebaseAnalytics

/// The main navigation controller that is responsible for moving between screens
class MainNavigationController: UINavigationController {
    
    private let storage = Storage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        identifierHelper()
    }
}

fileprivate extension MainNavigationController {
    private func identifierHelper() {
        if let id = UIDevice.current.identifierForVendor {
            let uuid = id.uuidString
            Storage.shared.userinfo[.kIdentifier] = uuid
            Analytics.setUserID(uuid)
            Analytics.setUserProperty(uuid, forName: "identifierForVendor")
            Analytics.logEvent(AnalyticsEventAppOpen, parameters: [
                AnalyticsParameterItemID: "identifierForVendor",
                AnalyticsParameterItemName: uuid,
            ])
        }
    }
}
