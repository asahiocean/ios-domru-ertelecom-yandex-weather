import Foundation
import RealmSwift

final class RealmService {
    
    private let config: Realm.Configuration
    private let queue: DispatchQueue
    
    func fetch<O: Object>(_ key: String = String(describing: O.self), _ completion: @escaping ((O?)->())) {
        queue.async {
            autoreleasepool { [self] in
                do {
                    let realm = try Realm(configuration: config,
                                          queue: queue)
                    let obj = realm.object(ofType: O.self,
                                           forPrimaryKey: key)
                    completion(obj)
                } catch let error as NSError {
                    fatalError(error.localizedDescription)
                    // completion(nil)
                }
            }
        }
    }
    
    func objects<O:Object>(_ completion: @escaping ([O]?)->()) {
        queue.async {
            autoreleasepool { [self] in
                do {
                    let realm = try Realm(configuration: config,
                                          queue: queue)
                    let objects = realm.objects(O.self)
                    let array = Array(objects)
                    completion(array)
                } catch let error as NSError {
                    fatalError(error.localizedDescription)
                    // completion(nil)
                }
            }
        }
    }
    
    func add<O:Object>(_ object: O) {
        queue.async {
            autoreleasepool { [self] in
                do {
                    let realm = try Realm(configuration: config,
                                          queue: queue)
                    try realm.write {
                        realm.add(object, update: .modified)
                    }
                } catch let error as NSError {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    func createOrUpdate<O:Object>(_ objType: O, _ value: Any = [:]) {
        queue.async {
            autoreleasepool { [self] in
                do {
                    let realm = try Realm(configuration: config,
                                          queue: queue)
                    try realm.write {
                        realm.create(O.self,
                                     value: value,
                                     update: .modified)
                    }
                } catch let error as NSError {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    init(with customQueue: DispatchQueue = .init(label: "com.realm.defaultQueue", qos: .default)) {
        self.queue = customQueue
        self.config = .defaultConfiguration
    }
}
