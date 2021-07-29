import Foundation

typealias Country = CountryModel
struct CountryModel: Codable {
    
    let id: Int?
    let name: String?
    
    internal init(id: Int? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        id = dict["id"] as? Int
        name = dict["name"] as? String
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
    }
}

extension CountryModel {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        return jsonDict
    }
}
