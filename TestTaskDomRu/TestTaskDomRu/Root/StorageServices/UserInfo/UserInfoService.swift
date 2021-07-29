import Foundation

class UserInfoService {
    
    private let keychain: KeychainService
    
    public subscript(_ key: UserInfoKeys) -> String? {
        get {
            return keychain[key.secretKey]
        }
        set(newValue) {
            if let value = newValue {
                keychain[key.secretKey] = value
            }
        }
    }
    
    init() {
        self.keychain = KeychainService()
    }
}

fileprivate extension UserInfoService {
    private class KeychainService {
        subscript(key: String) -> String? {
            get {
                return getValue(for: key)
            }
            set(newValue) {
                if let value = newValue { setValue(value, key: key) }
            }
        }
        
        private func setValue(_ value: String, key: String) {
            let data = value.data(using: .utf8)!
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrAccount as String: key,
                                        kSecValueData as String: data]
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else { return }
        }
        
        private func getValue(for key: String) -> String? {
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrAccount as String: key,
                                        kSecMatchLimit as String: kSecMatchLimitOne,
                                        kSecReturnData as String: kCFBooleanTrue as CFBoolean]
            
            var retrivedData: AnyObject? = nil
            SecItemCopyMatching(query as CFDictionary, &retrivedData)
            guard let data = retrivedData as? Data else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }
}

// MARK: - UserInfo Secret Keys List

fileprivate extension UserInfoKeys {
    var secretKey: String {
        switch self {
        case .kIdentifier:
            return "ygWSNhFKzDKmg9nI4bHHBnEZq6T1amj9"
        case .kIpAddress:
            return "cja4D1pKOeMlXCTQWugTy3Vho7UOGfhl"
        case .kLatLong:
            return "87x2qYDxsZhiwJ6fYZsvJ7jc2cdFgCiO"
        }
    }
}
