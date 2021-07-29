import Foundation

typealias Weather = WeatherModel
struct WeatherModel: Codable {
    
    let now: Double?
    let now_dt: String?
    let info: Info?
    let geoObject: GeoObject?
    let yesterday: Yesterday?
    let fact: Fact?
    let forecasts: [Forecast]?
    
    internal init(now: Double? = nil,
                  now_dt: String? = nil,
                  info: Info? = nil,
                  geoObject: GeoObject? = nil,
                  yesterday: Yesterday? = nil,
                  fact: Fact? = nil,
                  forecasts: [Forecast]? = nil) {
        self.now = now
        self.now_dt = now_dt
        self.info = info
        self.geoObject = geoObject
        self.yesterday = yesterday
        self.fact = fact
        self.forecasts = forecasts
    }
    
    private enum CodingKeys: String, CodingKey {
        case now = "now"
        case now_dt = "now_dt"
        case info = "info"
        case geoObject = "geo_object"
        case yesterday = "yesterday"
        case fact = "fact"
        case forecasts = "forecasts"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            now = try values.decodeIfPresent(Double.self, forKey: .now)
        } catch DecodingError.typeMismatch {
            let value = try values.decode(Int.self, forKey: .now)
            now = Double(value)
        }
        now_dt = try values.decodeIfPresent(String.self, forKey: .now_dt)
        info = try values.decodeIfPresent(Info.self, forKey: .info)
        geoObject = try values.decodeIfPresent(GeoObject.self, forKey: .geoObject)
        yesterday = try values.decodeIfPresent(Yesterday.self, forKey: .yesterday)
        fact = try values.decodeIfPresent(Fact.self, forKey: .fact)
        forecasts = try values.decodeIfPresent([Forecast].self, forKey: .forecasts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(now, forKey: .now)
        try container.encodeIfPresent(now_dt, forKey: .now_dt)
        try container.encodeIfPresent(info, forKey: .info)
        try container.encodeIfPresent(geoObject, forKey: .geoObject)
        try container.encodeIfPresent(yesterday, forKey: .yesterday)
        try container.encodeIfPresent(fact, forKey: .fact)
        try container.encodeIfPresent(forecasts, forKey: .forecasts)
    }
}
