import Foundation

typealias Hour = HourModel
struct HourModel: Codable {
    
    let hour: String?
    let hourTs: Double?
    let temp: Double?
    let feelsLike: Double?
    let tempWater: Double?
    let icon: String?
    let condition: String?
    let cloudness: Double?
    let precType: Double?
    let precStrength: Double?
    let isThunder: Bool?
    let windDir: String?
    let windSpeed: Double?
    let windGust: Double?
    let pressureMm: Double?
    let pressurePa: Double?
    let humidity: Double?
    let uvIndex: Double?
    let soilTemp: Double?
    let soilMoisture: Double?
    let precMm: Double?
    let precPeriod: Double?
    let precProb: Double?
    
    internal init(hour: String? = nil,
                  hourTs: Double? = nil,
                  temp: Double? = nil,
                  feelsLike: Double? = nil,
                  tempWater: Double? = nil,
                  icon: String? = nil,
                  condition: String? = nil,
                  cloudness: Double? = nil,
                  precType: Double? = nil,
                  precStrength: Double? = nil,
                  isThunder: Bool? = nil,
                  windDir: String? = nil,
                  windSpeed: Double? = nil,
                  windGust: Double? = nil,
                  pressureMm: Double? = nil,
                  pressurePa: Double? = nil,
                  humidity: Double? = nil,
                  uvIndex: Double? = nil,
                  soilTemp: Double? = nil,
                  soilMoisture: Double? = nil,
                  precMm: Double? = nil,
                  precPeriod: Double? = nil,
                  precProb: Double? = nil) {
        self.hour = hour
        self.hourTs = hourTs
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempWater = tempWater
        self.icon = icon
        self.condition = condition
        self.cloudness = cloudness
        self.precType = precType
        self.precStrength = precStrength
        self.isThunder = isThunder
        self.windDir = windDir
        self.windSpeed = windSpeed
        self.windGust = windGust
        self.pressureMm = pressureMm
        self.pressurePa = pressurePa
        self.humidity = humidity
        self.uvIndex = uvIndex
        self.soilTemp = soilTemp
        self.soilMoisture = soilMoisture
        self.precMm = precMm
        self.precPeriod = precPeriod
        self.precProb = precProb
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        hour = dict["hour"] as? String
        hourTs = dict["hour_ts"] as? Double
        temp = dict["temp"] as? Double
        feelsLike = dict["feels_like"] as? Double
        tempWater = dict["temp_water"] as? Double
        icon = dict["icon"] as? String
        condition = dict["condition"] as? String
        cloudness = dict["cloudness"] as? Double
        precType = dict["prec_type"] as? Double
        precStrength = dict["prec_strength"] as? Double
        isThunder = dict["is_thunder"] as? Bool
        windDir = dict["wind_dir"] as? String
        windSpeed = dict["wind_speed"] as? Double
        windGust = dict["wind_gust"] as? Double
        pressureMm = dict["pressure_mm"] as? Double
        pressurePa = dict["pressure_pa"] as? Double
        humidity = dict["humidity"] as? Double
        uvIndex = dict["uv_index"] as? Double
        soilTemp = dict["soil_temp"] as? Double
        soilMoisture = dict["soil_moisture"] as? Double
        precMm = dict["prec_mm"] as? Double
        precPeriod = dict["prec_period"] as? Double
        precProb = dict["prec_prob"] as? Double
    }
    
    private enum CodingKeys: String, CodingKey {
        case hour = "hour"
        case hourTs = "hour_ts"
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempWater = "temp_water"
        case icon = "icon"
        case condition = "condition"
        case cloudness = "cloudness"
        case precType = "prec_type"
        case precStrength = "prec_strength"
        case isThunder = "is_thunder"
        case windDir = "wind_dir"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case pressureMm = "pressure_mm"
        case pressurePa = "pressure_pa"
        case humidity = "humidity"
        case uvIndex = "uv_index"
        case soilTemp = "soil_temp"
        case soilMoisture = "soil_moisture"
        case precMm = "prec_mm"
        case precPeriod = "prec_period"
        case precProb = "prec_prob"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hour = try values.decodeIfPresent(String.self, forKey: .hour)
        hourTs = try values.decodeIfPresent(Double.self, forKey: .hourTs)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        feelsLike = try values.decodeIfPresent(Double.self, forKey: .feelsLike)
        tempWater = try values.decodeIfPresent(Double.self, forKey: .tempWater)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        condition = try values.decodeIfPresent(String.self, forKey: .condition)
        cloudness = try values.decodeIfPresent(Double.self, forKey: .cloudness)
        precType = try values.decodeIfPresent(Double.self, forKey: .precType)
        precStrength = try values.decodeIfPresent(Double.self, forKey: .precStrength)
        isThunder = try values.decodeIfPresent(Bool.self, forKey: .isThunder)
        windDir = try values.decodeIfPresent(String.self, forKey: .windDir)
        windSpeed = try values.decodeIfPresent(Double.self, forKey: .windSpeed)
        windGust = try values.decodeIfPresent(Double.self, forKey: .windGust)
        pressureMm = try values.decodeIfPresent(Double.self, forKey: .pressureMm)
        pressurePa = try values.decodeIfPresent(Double.self, forKey: .pressurePa)
        humidity = try values.decodeIfPresent(Double.self, forKey: .humidity)
        uvIndex = try values.decodeIfPresent(Double.self, forKey: .uvIndex)
        soilTemp = try values.decodeIfPresent(Double.self, forKey: .soilTemp)
        soilMoisture = try values.decodeIfPresent(Double.self, forKey: .soilMoisture)
        precMm = try values.decodeIfPresent(Double.self, forKey: .precMm)
        precPeriod = try values.decodeIfPresent(Double.self, forKey: .precPeriod)
        precProb = try values.decodeIfPresent(Double.self, forKey: .precProb)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(hour, forKey: .hour)
        try container.encodeIfPresent(hourTs, forKey: .hourTs)
        try container.encodeIfPresent(temp, forKey: .temp)
        try container.encodeIfPresent(feelsLike, forKey: .feelsLike)
        try container.encodeIfPresent(tempWater, forKey: .tempWater)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encodeIfPresent(condition, forKey: .condition)
        try container.encodeIfPresent(cloudness, forKey: .cloudness)
        try container.encodeIfPresent(precType, forKey: .precType)
        try container.encodeIfPresent(precStrength, forKey: .precStrength)
        try container.encodeIfPresent(isThunder, forKey: .isThunder)
        try container.encodeIfPresent(windDir, forKey: .windDir)
        try container.encodeIfPresent(windSpeed, forKey: .windSpeed)
        try container.encodeIfPresent(windGust, forKey: .windGust)
        try container.encodeIfPresent(pressureMm, forKey: .pressureMm)
        try container.encodeIfPresent(pressurePa, forKey: .pressurePa)
        try container.encodeIfPresent(humidity, forKey: .humidity)
        try container.encodeIfPresent(uvIndex, forKey: .uvIndex)
        try container.encodeIfPresent(soilTemp, forKey: .soilTemp)
        try container.encodeIfPresent(soilMoisture, forKey: .soilMoisture)
        try container.encodeIfPresent(precMm, forKey: .precMm)
        try container.encodeIfPresent(precPeriod, forKey: .precPeriod)
        try container.encodeIfPresent(precProb, forKey: .precProb)
    }
}

extension Hour {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["hour"] = hour
        jsonDict["hour_ts"] = hourTs
        jsonDict["temp"] = temp
        jsonDict["feels_like"] = feelsLike
        jsonDict["temp_water"] = tempWater
        jsonDict["icon"] = icon
        jsonDict["condition"] = condition
        jsonDict["cloudness"] = cloudness
        jsonDict["prec_type"] = precType
        jsonDict["prec_strength"] = precStrength
        jsonDict["is_thunder"] = isThunder
        jsonDict["wind_dir"] = windDir
        jsonDict["wind_speed"] = windSpeed
        jsonDict["wind_gust"] = windGust
        jsonDict["pressure_mm"] = pressureMm
        jsonDict["pressure_pa"] = pressurePa
        jsonDict["humidity"] = humidity
        jsonDict["uv_index"] = uvIndex
        jsonDict["soil_temp"] = soilTemp
        jsonDict["soil_moisture"] = soilMoisture
        jsonDict["prec_mm"] = precMm
        jsonDict["prec_period"] = precPeriod
        jsonDict["prec_prob"] = precProb
        return jsonDict
    }
}
