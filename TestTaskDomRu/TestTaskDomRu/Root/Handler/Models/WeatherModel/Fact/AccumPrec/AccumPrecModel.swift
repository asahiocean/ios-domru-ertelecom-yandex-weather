import Foundation

typealias AccumPrec = AccumPrecModel
struct AccumPrecModel: Codable {
    
    let one: Double?
    let three: Double?
    let seven: Double?
    
    enum CodingKeys: String, CodingKey {
        case one = "1"
        case three = "3"
        case seven = "7"
    }
    
    internal init(one: Double? = nil, three: Double? = nil, seven: Double? = nil) {
        self.one = one
        self.three = three
        self.seven = seven
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        one = dict["1"] as? Double
        three = dict["3"] as? Double
        seven = dict["7"] as? Double
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        one = try values.decodeIfPresent(Double.self, forKey: .one)
        three = try values.decodeIfPresent(Double.self, forKey: .three)
        seven = try values.decodeIfPresent(Double.self, forKey: .seven)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(one, forKey: .one)
        try container.encodeIfPresent(three, forKey: .three)
        try container.encodeIfPresent(seven, forKey: .seven)
    }
}

extension AccumPrec {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["1"] = one
        jsonDict["3"] = three
        jsonDict["7"] = seven
        return jsonDict
    }
}
