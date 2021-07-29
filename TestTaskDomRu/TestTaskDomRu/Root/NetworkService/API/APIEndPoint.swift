import Foundation
import Moya

enum APIEndPoint {
    case forecast(_ request: API.Request)
}

extension APIEndPoint: Moya.TargetType {
    
    var fullURL: Moya.URL {
        var base = baseURL
        guard path.contains("?"), let urlstr = base.appendingPathComponent(path).absoluteString.removingPercentEncoding
        else {
            base.appendPathComponent(path, isDirectory: baseURL.isDirectory)
            return base
        }
        return Moya.URL(string: urlstr)!
    }
    
    /// Address of the server hosting the API
    public var baseURL: Moya.URL {
        return API.baseURL
    }
    
    /// Request path
    public var path: String {
        switch self {
        case .forecast:
            return "forecast"
        }
    }
    
    /// Method to be sent
    ///
    /// Methods provided from Alamofire
    public var method: Moya.Method {
        switch self {
        case .forecast:
            return .get
        }
    }
    
    public var sampleData: Moya.Data {
        switch self {
        case .forecast:
            return Data()
        }
    }
    
    private func paramsHelper(for subject: Any) -> [String:Any] {
        let mirror = Mirror(reflecting: subject)
        var result: [String:Any] = [:]
        for (label,value) in mirror.children {
            guard let label = label else { continue }
            let value = Optional<Any>.some(value)
            // Removing the wrapper Optional("...")
            if let param = value as? String {
                result[label] = param
            }
        }
        return result
    }
    
    /// Request parameters
    public var parameters: [String:Any] {
        switch self {
        case .forecast(let request):
            return paramsHelper(for: request)
        }
    }
    
    /// Task to be completed
    public var task: Moya.Task {
        switch self {
        case .forecast:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"
        ]
    }
    
    /// Encoding of parameters
    ///
    /// Parameters are taken from Alamofire
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .forecast:
            return JSONEncoding.default
        }
    }
}
