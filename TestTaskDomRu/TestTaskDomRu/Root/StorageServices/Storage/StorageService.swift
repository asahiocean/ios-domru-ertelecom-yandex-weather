import Foundation

protocol StorageModelDelegate: AnyObject {
    func updatedModel(with model: WeatherModel)
}

typealias Storage = StorageService
final class StorageService {
    
    public static let shared = StorageService()
    weak var delegate: StorageModelDelegate?
    
    public let userinfo: UserInfoService
    public let defaults: UserDefaultsHelper
    private let realm: RealmService
    
    private(set) var model: WeatherModel?
    private(set) var array: [Data] = []
    
    private let listID = "WeatherList"
    private lazy var archive: WeatherListRealmObject = {
        return .init(value: ["id":listID])
    }()
    
    private let queue: DispatchQueue
    
    func saveModel(_ model: WeatherModel, _ notify: ((Bool)->())?) {
        let group = DispatchGroup()
        group.enter()
        queue.async(group: group, execute: {
            self.model = model
            group.leave()
        })
        group.notify(queue: .main, execute: { [self] in
            delegate?.updatedModel(with: model)
            notify?(true)
        })
    }
    
    func saveModelData(_ data: Data, _ id: String, _ notify: ((Bool)->())?) {
        array.append(data)
        let group = DispatchGroup()
        group.enter()
        queue.async(group: group, execute: { [self] in
            let value: [String:Any] = [
                "id": id,
                "data": data
            ]
            let object = WeatherRealmObject(value: value)
            realm.add(object)
            
            archive.list.append(object)
            
            realm.createOrUpdate(archive, ["id": listID,
                                           "list":archive.list])
            group.leave()
        })
        group.notify(queue: .main, execute: {
            notify?(true)
        })
    }
    
    private func loadWeatherDataList() {
        queue.async { [self] in
            realm.objects({ (arr: [WeatherRealmObject]?) in
                guard let items = arr else { return }
                for item in items {
                    guard let data = item.data else { return }
                    autoreleasepool {
                        array.append(data)
                    }
                }
            })
            realm.fetch(listID, { (obj: WeatherListRealmObject?) in
                if let items = obj {
                    for item in items.list {
                        autoreleasepool {
                            archive.list.append(item)
                        }
                    }
                }
            })
        }
    }
    
    fileprivate init() {
        self.realm = RealmService()
        self.queue = .init(label: "com.storage.queue")
        self.userinfo = UserInfoService()
        self.defaults = UserDefaultsHelper()
        self.loadWeatherDataList()
    }
}
