import Foundation
import RealmSwift

final class WeatherListRealmObject: Object {
    
    @objc dynamic var id: String = String(describing: self)
    dynamic var list: List<WeatherRealmObject> = .init()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

final class WeatherRealmObject: Object {
    @objc dynamic var data: Data?
    
    @objc dynamic var id = String(describing: self)
    override static func primaryKey() -> String? {
        return "id"
    }
    
    let listPart = LinkingObjects(fromType: WeatherListRealmObject.self, property: "list")
}
