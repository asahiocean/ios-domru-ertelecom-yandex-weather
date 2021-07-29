import Foundation

extension String {
    public var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
