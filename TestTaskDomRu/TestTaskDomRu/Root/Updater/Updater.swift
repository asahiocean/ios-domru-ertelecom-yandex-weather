import Foundation
import FirebaseAnalytics

protocol UpdaterDelegate: AnyObject {
    func notify(with status: UpdaterStatus)
}

/// A separate independent class for updating and processing information with the weather forecast
final class Updater {
    
    public static let shared = Updater()
    weak var delegate: UpdaterDelegate?
    
    private let api: APIService // Working with the API
    private let handler: Handler // Working with the data handler
    private let storage = Storage.shared // Working with the storage
    
    /// Notifies whether the data exists in the storage
    var lastDataNotNil: Bool { storage.array.last != nil }
    
    /// Stores information about the last connection endpoint
    private var lastEndPoint: APIEndPoint?
    
    /// Stores information about the last connection time
    private var timestamp: Int = 0
    private var currentDayNum: Int = 0
    
    /// A separate dedicated queue for the update service to work
    private let queue = DispatchQueue(label: "com.updater.queue", qos: .default)
    
    /// A separate dedicated queue for RunLoop
    private let queueRunLoop = DispatchQueue(label: "com.updater.runloop", qos: .default)
    
    /// RunLoop that is responsible for automatic updates
    private var runLoop: RunLoop?
    
    /// Method for restoring a model from previously saved data
    public func restore() {
        let oldDay: Int = storage.defaults[.kDayOfMonth] ?? 0
        // Getting the last element of the model data array
        if oldDay == currentDayNum, let data = storage.array.last {
            jsonHandler(with: data, { [self] _ in
                delegate?.notify(with: .request(.completed))
                if runLoop == nil { runLoopConfigure() }
            })
        } else {
            restoreUpdateType({ self.startSession(ofType: $0) })
        }
    }
    
    /// Method for starting the update session
    public func startSession(ofType: ForecastUpdate? = nil) {
        if let endPoint = lastEndPoint {
            // Starting session using a previously saved endpoint
            requestEndPoint(for: endPoint, in: queue)
        } else if let type = ofType {
            // Saving index of the selected update method
            storage.defaults[.kFUpdateIndex] = type.index
            requestEndPoint(for: type.endPoint, in: queue)
        } else {
            fatalError("Make a spare one endPoint!")
        }
        if runLoop == nil { runLoopConfigure() }
    }
    
    /// Initialization and configuration for RunLoop
    private func runLoopConfigure() {
        let delay: TimeInterval = 10 // (60*5) // Interval for the timer
        let timer = Timer(timeInterval: delay, repeats: true) {
            // Acceptable delay starting the timer
            $0.tolerance = 5
            // Method for the timer
            self.updaterRunLoopMethod($0)
        }
        
        // RunLoop for data update check
        queueRunLoop.async { [self] in
            runLoop = RunLoop.current
            runLoop?.add(timer, forMode: .default)
            runLoop?.run()
        }
    }
    
    /// A method for a RunLoop with a timer passed in a parameter for further work with it
    fileprivate func updaterRunLoopMethod(_ timer: Timer?) {
        self.startSession()
    }
    
    /// Private method for working with a request
    private func requestEndPoint(for endPoint: APIEndPoint, in queue: DispatchQueue) {
        let ts = Int(Date().timeIntervalSince1970) // request timestamp
        let notify = delegate?.notify // making a "link" to the method
        switch (ts - 60) < timestamp {
        case true:
            guard storage.model == nil else { return }
            // Getting the last element of the model data array
            if let data = storage.array.last {
                queue.async {
                    self.jsonHandler(with: data, { _ in
                        notify?(.request(.completed))
                    })
                }
            } else {
                fallthrough
            }
        default:
            timestamp = ts
            storage.defaults[.kTimestamp] = ts
            storage.defaults[.kDayOfMonth] = currentDayNum
            lastEndPoint = endPoint
            queue.async { [self] in
                notify?(.request(.accepted))
                api.forecast(endPoint, { (data: Data?) in
                    if let data = data {
                        notify?(.request(.received))
                        let id = String(ts) // using unix-time as an identifier
                        storage.saveModelData(data, id, nil)
                        jsonHandler(with: data, { _ in
                            notify?(.request(.completed))
                        })
                    } else {
                        notify?(.error(.invalidData))
                    }
                })
            }
        }
    }
    
    /// Data processing method for the Weather model
    private func jsonHandler(with data: Data, _ completion: @escaping ((Bool)->())) {
        typealias Results = Result<Weather,Error>
        handler.json.decoder(data, { [self] (result: Results) in
            switch result {
            case let .success(weather):
                delegate?.notify(with: .request(.processed))
                storage.saveModel(weather, { (completed) in
                    completion(completed)
                })
            case let .failure(error):
                print(#function, error)
                fatalError("МОДЕЛЬ НЕ ПОДХОДИТ! СМ. ОШИБКУ И JSON!!!")
            //notify?(.error(.parserError(error)))
            }
        })
    }
    
    fileprivate init() {
        handler = Handler()
        api = APIService()
        currentDayNum = Calendar.current.component(.day, from: Date())
        restoreUpdateType({ self.lastEndPoint = $0.endPoint })
    }
}

extension Updater {
    enum ForecastUpdate: CaseIterable {
        case standart
        case detailed
        
        var endPoint: APIEndPoint {
            switch self {
            case .standart:
                return .forecast(request)
            case .detailed:
                return .forecast(request)
            }
        }
        
        var request: API.Request {
            let pos = TempCache.latLong
            switch self {
            case .standart:
                return .init(lat: pos.lat,
                             lon: pos.lon,
                             extra: .true)
            case .detailed:
                return .init(lat: pos.lat,
                             lon: pos.lon,
                             lang: .ru_RU,
                             limit: 7,
                             hours: .true,
                             extra: .true)
            }
        }
        
        var index: Int {
            return Self.allCases.firstIndex(of: self)!
        }
    }
    
    /// Method for restoring the index of the update type
    private func restoreUpdateType(_ completion: @escaping ((Updater.ForecastUpdate)->())) {
        //  0 == standart, 1 == detailed
        let index: Int? = storage.defaults[.kFUpdateIndex]
        completion(.allCases[index ?? 1])
    }
}
