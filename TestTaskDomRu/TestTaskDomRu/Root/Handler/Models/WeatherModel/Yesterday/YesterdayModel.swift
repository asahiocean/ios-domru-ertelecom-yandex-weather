import Foundation

typealias Yesterday = YesterdayModel
struct YesterdayModel: Codable {
    
    let temp: Double?
    
    internal init(temp: Double? = nil) {
        self.temp = temp
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        switch dict["temp"] {
        case let value as Double:
            temp = value
        case let value as Int:
            temp = Double(value)
        default:
            return nil
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case temp = "temp"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .temp) {
                temp = Double(value)
            } else {
                temp = nil
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(temp, forKey: .temp)
    }
}

extension YesterdayModel {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["temp"] = temp
        return jsonDict
    }
}
