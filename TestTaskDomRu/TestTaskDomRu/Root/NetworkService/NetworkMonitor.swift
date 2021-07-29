import Foundation
import Network
import SystemConfiguration

class NetworkMonitor {
    
    public static let shared = NetworkMonitor()
    
    private let group = DispatchGroup()
    private let queue = DispatchQueue(label: "com.network.monitor", qos: .background)
    private var timer: Timer?
    
    private(set) var IPAddress: String?
    private(set) var isAvailable: Bool = false
    
    func start() {
        if #available(iOS 12.0, *) {
            let monitor = NWPathMonitor()
            func checkNWPath(_ path: NWPath) {
                switch path.status {
                case .satisfied: checkMyIP()
                case .requiresConnection: break
                case .unsatisfied:
                    #if targetEnvironment(simulator)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.isAvailable = Self.isConnected
                        self.checkMyIP()
                    })
                    #endif
                @unknown default: fatalError()
                }
            }
            monitor.start(queue: queue)
            monitor.pathUpdateHandler = { checkNWPath($0) }
        } else {
            autoConnection()
        }
        
        func autoConnection() {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
                self.backgroundUpdater($0)
            }
        }
    }
    
    /// Method for checking Internet connection for iOS versions below 12
    @objc private func backgroundUpdater(_ timer: Timer) {
        queue.async(group: group, execute: {
            self.isAvailable = NetworkMonitor.isConnected
        })
    }
    
    private func checkMyIP() {
        whatIsMyIpAddress({ [self] in
            isAvailable = $0 != nil
            IPAddress = $0
        })
    }
    
    /// Method for getting an IP address
    public func whatIsMyIpAddress(_ completion: @escaping ((String?)->())) {
        if let url = URL(string: URLS.whatIsMyIpAddress) {
            completion(try? String(contentsOf: url))
        }
    }
    
    /// Variable for getting the network connection status
    private static var isConnected: Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { sockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, sockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) { return false }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    fileprivate init() {
        
    }
}
