import Foundation
import Moya
import FirebaseAnalytics

typealias API = APIService
final class APIService: NetworkService {
    
    public static let shared = APIService()
    private let storage = Storage.shared
    
    // MARK: - Private properties -
    
    fileprivate static let APIKey = "X-Yandex-API-Key"
    fileprivate static let callbackQueue = DispatchQueue(label: "com.api.callbackQueue", qos: .utility)
    
    // MARK: - Public properties -
    
    public static let version: Version = .v2
    
    public static let baseURL: URL = {
        let comp = NSURLComponents()
        comp.scheme = "https"
        comp.host = URLS.apiHost
        comp.path = "/\(version)/"
        return comp.url!
    }()
    
    private let provider = MoyaProvider<APIEndPoint>(
        endpointClosure: APIService.endpointClosure,
        requestClosure: APIService.requestClosure,
        stubClosure: stubAction,
        callbackQueue: callbackQueue,
        session: customSession(),
        plugins: [],
        trackInflights: false)
    
    func forecast(_ endPoint: APIEndPoint, _ completion: @escaping ((Data?)->())) {
        provider.request(endPoint, completion: { result in
            switch result {
            case let .success(response):
                completion(response.data)
            case let .failure(error):
                fatalError(error.localizedDescription)
            }
        })
    }
    
    private let urlComponents: URLComponents = {
        let comp = NSURLComponents()
        comp.scheme = "https"
        comp.host = URLS.apiHost
        return comp as URLComponents
    }()
    
    // MARK: - Request constructor -
    
    struct Request {
        let lat: String
        let lon: String
        var lang: String? = nil
        var limit: String? = nil
        var hours: String? = nil
        let extra: String
        
        /**
         - Parameters:
         - lat: Latitude in degrees. **Required parameter!**
         - lon: Longitude in degrees. **Required parameter!**
         - lang: Response language
         - limit: The number of days in the forecast, including the current one. For the "Test" tariff, the maximum allowed value is 7.
         -  hours: For each of the days, the response will contain the weather forecast by the hour. Default value: `true`
         - extra: Advanced information about precipitation. Default value: `false`
         */
        public init(lat: String,
                    lon: String,
                    lang: Lang? = nil,
                    limit: Int? = nil,
                    hours: Hours? = nil,
                    extra: Extra) {
            self.lat = lat
            self.lon = lon
            self.lang = lang?.rawValue
            self.limit = limit?.description
            self.hours = hours?.rawValue
            self.extra = extra.rawValue
        }
    }
    
    // MARK: - Initializer -
    
    override init() {
        
    }
}

extension APIService {
    @frozen enum Version: String, CaseIterable, RawRepresentable {
        case `v1` // DEPRECATED
        case `v2`
    }
    
    /// Combinations of the language and country for which the weather wording data will be returned.
    @frozen enum Lang: String, CaseIterable, RawRepresentable {
        /// Russian for the domain of Russia.
        case ru_RU
        /// Russian for the domain of Ukraine.
        case ru_UA
        /// Ukrainian language for the domain of Ukraine.
        case uk_UA
        /// Belarusian for the domain of Belarus.
        case be_BY
        /// Kazakh for the domain of Kazakhstan
        case kk_KZ
        /// Turkish for the domain of Turkish.
        case tr_TR
        /// International English.
        case en_US
    }
    
    /// For each of the days, the response will contain the weather forecast by the hour.
    @frozen enum Hours: String, CaseIterable, RawRepresentable {
        /// Default value, hourly forecast is returned.
        case `true`
        /// The hourly forecast is not returned.
        case `false`
    }
    
    /// Advanced precipitation information.
    @frozen enum Extra: String, CaseIterable, RawRepresentable {
        /// Advanced precipitation information is returned.
        case `true`
        /// Default value, extended precipitation information is not returned.
        case `false`
    }
}

fileprivate extension APIService {
    private static let endpointClosure = { (target: APIEndPoint) -> Endpoint in
        let url = URL(target: target).absoluteString
        return .init(url: url, sampleResponseClosure: {
            .networkResponse(200, target.sampleData)
        },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers)
    }
    
    private static let requestClosure = { (endpoint: Endpoint, closure: (Result<URLRequest,MoyaError>)->Void) -> Void in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 60
            request.cachePolicy = .returnCacheDataElseLoad
            request.httpShouldHandleCookies = false
            request.networkServiceType = .default
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "X-Yandex-API-Key": APIKey,
                "Cache-Control": "max-age=7200, must-revalidate, private"
            ]
            closure(.success(request))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(.parameterEncoding(error)))
        } catch {
            closure(.failure(.underlying(error, nil)))
        }
    }
    
    private static let stubAction:(_ type: APIEndPoint) -> Moya.StubBehavior = { type in
        switch type {
        case .forecast:
            return Moya.StubBehavior.never
        }
    }
}

extension APIService {
    /// This method will help determine the approximate location of the user using his IP address, using a third-party service.
    ///
    /// If the response is successful, the approximate coordinates will be returned, which override the default values.
    /// To avoid using a third-party service, can make your own.
    public func latLongHelper() {
        if let url = URL(string: URLS.apiLatLong) {
            do {
                // The query results in the form of a string
                // Example: 55.833333,37.616667
                let string = try String(contentsOf: url)
                // There may probably be spaces in the string,
                // so using 'trimmingCharacters' and select 'whitespaces'
                let latLong = string.trimmingCharacters(in: .whitespaces)
                // The simplest solution is to divide the string
                // into parts by focusing on the comma
                // As a result get: ["55.833333", "37.616667"]
                let array = latLong.components(separatedBy: ",")
                // Creating a named tuple for convenience
                let result = (lat: array[0], lon: array[1])
                // MARK: Override the default value
                TempCache.latLong = result
                storage.userinfo[.kLatLong] = latLong
                Analytics.setUserProperty(latLong, forName: "latLong")
            } catch let error {
                print("❗️", #function, error.localizedDescription)
            }
        }
    }
}
