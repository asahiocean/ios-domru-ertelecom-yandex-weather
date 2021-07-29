import Foundation

class UserDefaultsHelper {
    
    private let defaults: UserDefaults!
    
    public subscript<T>(key: String) -> T? {
        get {
            return defaults.value(forKey: key) as? T
        }
        set {
            if let value = newValue {
                defaults.setValue(value, forKey: key)
                defaults.synchronize()
            } else {
                defaults.setNilValueForKey(key)
            }
        }
    }
    
    init(for defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}

extension String {
    static var kTimestamp: String { "keyUserDefaultsTimestamp" }
    static var kDayOfMonth: String { "keyUserDefaultsDayOfMonth" }
    static var kFUpdateIndex: String { "keyUserDefaultsForecastUpdateIndex" }
}
