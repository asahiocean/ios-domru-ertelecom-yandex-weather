import Foundation

typealias Biomet = BiometModel
struct BiometModel: Codable {
    
    let index: Int?
    let condition: String?
    
    internal init(index: Int?, condition: String?) {
        self.index = index
        self.condition = condition
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        index = dict["index"] as? Int
        condition = dict["condition"] as? String
    }
    
    private enum CodingKeys: String, CodingKey {
        case index = "index"
        case condition = "condition"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        condition = try values.decodeIfPresent(String.self, forKey: .condition)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(index, forKey: .index)
        try container.encodeIfPresent(condition, forKey: .condition)
    }
}

extension Biomet {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["index"] = index
        jsonDict["condition"] = condition
        return jsonDict
    }
}
