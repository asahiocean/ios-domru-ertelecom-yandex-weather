import Moya

protocol NetworkServiceable {
    func getRequest(_ config: Any?, _ completion: @escaping (Result<Data?,Error>) -> ()) throws
    func postRequest(_ config: Any?, _ body: [String:Any], _ completion: @escaping ((Result<Data?,Error>)->())) throws
    static func customSession() -> Moya.Session
}

open class NetworkService: NSObject, NetworkServiceable, URLSessionDelegate {
    
    public var isAvailable: Bool { return NetworkMonitor.shared.isAvailable }
    
    public enum HTTPMethod {
        static let post = "POST"
        static let get = "GET"
    }
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        if #available(iOS 11.0, *) {
            config.waitsForConnectivity = true
        } else {
            // Fallback on earlier versions
        }
        config.urlCache = urlCache
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    public func getRequest(_ config: Any?, _ completion: @escaping (Result<Data?,Error>) -> ()) throws {
        guard isAvailable else { throw URLError(.notConnectedToInternet) }
        let defaults = UserDefaults.standard
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var task: URLSessionDataTask!
        
        switch config {
        case let urlStr as String:
            guard let url = URL(string: urlStr.urlEscaped) else {
                completion(.failure(URLError(.badURL))); return
            }
            task = session.dataTask(with: url, completionHandler: { handler($0,$1,$2) })
        case let url as URL:
            task = session.dataTask(with: url, completionHandler: { handler($0,$1,$2) })
        case let request as URLRequest:
            if (timestamp - 7200) < defaults.integer(forKey: "timestamp") {
                guard let cached = urlCache.cachedResponse(for: request) else { return }
                handler(cached.data, cached.response, nil)
            } else {
                defaults.set(timestamp, forKey: "timestamp")
                task = session.dataTask(with: request, completionHandler: { data, response, error in
                    if error == nil, let data = data, let resp = response {
                        let cachedURLResponse = CachedURLResponse(response: resp, data: data, storagePolicy: .allowed)
                        urlCache.storeCachedResponse(cachedURLResponse, for: request) // OK
                    }
                    handler(data,response,error)
                })
            }
        default:
            fatalError("Unknown config value!")
        }
        
        func handler(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task?.resume()
    }
    
    
    public func postRequest(_ urlStr: Any?, _ body: [String:Any], _ completion: @escaping (Result<Data?,Error>) -> ()) throws {
        guard isAvailable else { throw URLError(.notConnectedToInternet) }
        guard let _ = urlStr else { throw URLError(.badURL) }
        fatalError("No implementation!")
    }
    
    final class func customSession() -> Moya.Session {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.headers = .default
        configuration.httpAdditionalHeaders = [:]
        configuration.httpCookieAcceptPolicy = .onlyFromMainDocumentDomain
        configuration.httpMaximumConnectionsPerHost = 16
        configuration.httpShouldUsePipelining = false
        configuration.networkServiceType = .default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.sessionSendsLaunchEvents = true
        configuration.shouldUseExtendedBackgroundIdleMode = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 604800
        configuration.urlCache = .shared
        if #available(iOS 11.0, *) {
            configuration.waitsForConnectivity = false
        } else {
            // Fallback on earlier versions
        }
        return Moya.Session(configuration: configuration, startRequestsImmediately: false)
    }
    
    override init() {
        super.init()
    }
}
