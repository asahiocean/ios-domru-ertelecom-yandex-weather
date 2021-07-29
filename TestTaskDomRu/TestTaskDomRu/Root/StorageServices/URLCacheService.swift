import Foundation

public var urlCache: URLCache = {
    let capacity: Int = (512 * 1024 * 1024) // 536870912 bytes ~ 512mb
    let urlCache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: "urlCache")
    return urlCache
}()
