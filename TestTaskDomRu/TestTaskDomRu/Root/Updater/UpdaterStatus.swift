import Foundation

enum UpdaterStatus {
    case request(_ state: ApiRequestState)
    case error(_ state: ApiErrorState)
}

enum ApiRequestState {
    case accepted, received, processed, completed
}

enum ApiErrorState: Swift.Error {
    case networkError
    case badRequest
    case parserError(_ error: Error?)
    case invalidData
}
