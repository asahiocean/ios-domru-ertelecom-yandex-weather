import Foundation

typealias TZinfo = TZinfoModel

/// Информация о часовом поясе. Содержит поля offset, name, abbr и dst.
///
/// https://yandex.ru/dev/weather/doc/dg/concepts/forecast-test.html#resp-format__info
struct TZinfoModel: Codable {
    
    let name: String?
    let abbr: String?
    let dst: Bool?
    let offset: Int?
    
    internal init(name: String? = nil,
                  abbr: String? = nil,
                  dst: Bool? = nil,
                  offset: Int? = nil) {
        self.name = name
        self.abbr = abbr
        self.dst = dst
        self.offset = offset
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        name = dict["name"] as? String
        abbr = dict["abbr"] as? String
        dst = dict["dst"] as? Bool
        offset = dict["offset"] as? Int
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case abbr = "abbr"
        case dst = "dst"
        case offset = "offset"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        abbr = try values.decodeIfPresent(String.self, forKey: .abbr)
        dst = try values.decodeIfPresent(Bool.self, forKey: .dst)
        offset = try values.decodeIfPresent(Int.self, forKey: .offset)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(abbr, forKey: .abbr)
        try container.encodeIfPresent(dst, forKey: .dst)
        try container.encodeIfPresent(offset, forKey: .offset)
    }
}

extension TZinfoModel {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["name"] = name
        jsonDict["abbr"] = abbr
        jsonDict["dst"] = dst
        jsonDict["offset"] = offset
        return jsonDict
    }
}
