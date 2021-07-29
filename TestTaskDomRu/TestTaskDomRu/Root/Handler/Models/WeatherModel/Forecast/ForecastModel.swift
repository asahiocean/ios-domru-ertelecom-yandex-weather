import Foundation

typealias Forecast = ForecastModel
struct ForecastModel: Codable {
    
    let date: String?
    let dateTs: Double?
    let week: Int?
    let sunrise: String?
    let sunset: String?
    let riseBegin: String?
    let setEnd: String?
    let moonCode: Int?
    let moonText: String?
    let parts: Parts?
    let hours: [Hour]?
    let biomet: Biomet?
    
    init?(_ dict: [String: Any?]?) {
        guard let dict = dict else { return nil }
        date = dict["date"] as? String
        dateTs = dict["date_ts"] as? Double
        week = dict["week"] as? Int
        sunrise = dict["sunrise"] as? String
        sunset = dict["sunset"] as? String
        riseBegin = dict["rise_begin"] as? String
        setEnd = dict["set_end"] as? String
        moonCode = dict["moon_code"] as? Int
        moonText = dict["moon_text"] as? String
        
        let partsDict = dict["parts"] as? [String:Any?]
        parts = Parts(partsDict)
        
        let hoursDictArray = dict["hours"] as? [[String:Any?]?]
        hours = hoursDictArray?.compactMap { Hour($0) }
        
        let biometDict = dict["biomet"] as? [String:Any?]
        biomet = Biomet(biometDict)
    }
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case dateTs = "date_ts"
        case week = "week"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case riseBegin = "rise_begin"
        case setEnd = "set_end"
        case moonCode = "moon_code"
        case moonText = "moon_text"
        case parts = "parts"
        case hours = "hours"
        case biomet = "biomet"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        dateTs = try values.decodeIfPresent(Double.self, forKey: .dateTs)
        week = try values.decode(Int.self, forKey: .week)
        sunrise = try values.decodeIfPresent(String.self, forKey: .sunrise)
        sunset = try values.decodeIfPresent(String.self, forKey: .sunset)
        riseBegin = try values.decodeIfPresent(String.self, forKey: .riseBegin)
        setEnd = try values.decodeIfPresent(String.self, forKey: .setEnd)
        moonCode = try values.decodeIfPresent(Int.self, forKey: .moonCode)
        moonText = try values.decodeIfPresent(String.self, forKey: .moonText)
        parts = try values.decodeIfPresent(Parts.self, forKey: .parts)
        hours = try values.decodeIfPresent([Hour].self, forKey: .hours)
        biomet = try values.decodeIfPresent(Biomet.self, forKey: .biomet)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encodeIfPresent(dateTs, forKey: .dateTs)
        try container.encodeIfPresent(week, forKey: .week)
        try container.encodeIfPresent(sunrise, forKey: .sunrise)
        try container.encodeIfPresent(sunset, forKey: .sunset)
        try container.encodeIfPresent(riseBegin, forKey: .riseBegin)
        try container.encodeIfPresent(setEnd, forKey: .setEnd)
        try container.encodeIfPresent(moonCode, forKey: .moonCode)
        try container.encodeIfPresent(moonText, forKey: .moonText)
        try container.encodeIfPresent(parts, forKey: .parts)
        try container.encodeIfPresent(hours, forKey: .hours)
        try container.encode(biomet, forKey: .biomet)
    }
}

extension Forecast {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["date"] = date
        jsonDict["date_ts"] = dateTs
        jsonDict["week"] = week
        jsonDict["sunrise"] = sunrise
        jsonDict["sunset"] = sunset
        jsonDict["rise_begin"] = riseBegin
        jsonDict["set_end"] = setEnd
        jsonDict["moon_code"] = moonCode
        jsonDict["moon_text"] = moonText
        jsonDict["parts"] = parts?.toDictionary()
        jsonDict["hours"] = hours?.map { $0.toDictionary() }
        jsonDict["biomet"] = biomet?.toDictionary()
        return jsonDict
    }
}
