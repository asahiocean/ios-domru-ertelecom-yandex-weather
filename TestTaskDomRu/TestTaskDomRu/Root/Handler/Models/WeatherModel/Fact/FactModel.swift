import Foundation

typealias Fact = FactModel

/// The object contains information about the weather at the moment.
///
/// https://yandex.ru/dev/weather/doc/dg/concepts/forecast-test.html#resp-format__fact
struct FactModel: Codable {
    
    let obsTime: Double?
    let uptime: Double?
    let temp: Double?
    let feelsLike: Double?
    let tempWater: Double?
    let icon: Icon?
    let condition: Condition?
    let cloudness: Double?
    let precType: Double?
    let precProb: Double?
    let precStrength: Double?
    let isThunder: Bool?
    let windSpeed: Double?
    let windDir: WindDir?
    let pressureMm: Double?
    let pressurePa: Double?
    let humidity: Double?
    let daytime: Daytime?
    let polar: Bool?
    let season: Season?
    let source: String?
    let accumPrec: AccumPrec?
    let soilMoisture: Double?
    let soilTemp: Double?
    let uvIndex: Double?
    let windGust: Double?
    
    internal init(obsTime: Double? = nil,
                  uptime: Double? = nil,
                  temp: Double? = nil,
                  feelsLike: Double? = nil,
                  tempWater: Double? = nil,
                  icon: Icon? = nil,
                  condition: Condition? = nil,
                  cloudness: Double? = nil,
                  precType: Double? = nil,
                  precProb: Double? = nil,
                  precStrength: Double? = nil,
                  isThunder: Bool? = nil,
                  windSpeed: Double? = nil,
                  windDir: WindDir? = nil,
                  pressureMm: Double? = nil,
                  pressurePa: Double? = nil,
                  humidity: Double? = nil,
                  daytime: Daytime? = nil,
                  polar: Bool? = nil,
                  season: Season? = nil,
                  source: String? = nil,
                  accumPrec: AccumPrec? = nil,
                  soilMoisture: Double? = nil,
                  soilTemp: Double? = nil,
                  uvIndex: Double? = nil,
                  windGust: Double? = nil) {
        self.obsTime = obsTime
        self.uptime = uptime
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempWater = tempWater
        self.icon = icon
        self.condition = condition
        self.cloudness = cloudness
        self.precType = precType
        self.precProb = precProb
        self.precStrength = precStrength
        self.isThunder = isThunder
        self.windSpeed = windSpeed
        self.windDir = windDir
        self.pressureMm = pressureMm
        self.pressurePa = pressurePa
        self.humidity = humidity
        self.daytime = daytime
        self.polar = polar
        self.season = season
        self.source = source
        self.accumPrec = accumPrec
        self.soilMoisture = soilMoisture
        self.soilTemp = soilTemp
        self.uvIndex = uvIndex
        self.windGust = windGust
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        obsTime = dict["obs_time"] as? Double
        uptime = dict["uptime"] as? Double
        temp = dict["temp"] as? Double
        feelsLike = dict["feels_like"] as? Double
        tempWater = dict["temp_water"] as? Double
        icon = dict["icon"] as? Icon
        condition = dict["condition"] as? Condition
        
        switch dict["cloudness"] {
        case let val as Double: cloudness = Double(val)
        case let val as Double: cloudness = val
        default: cloudness = nil
        }
        
        precType = dict["prec_type"] as? Double
        precProb = dict["prec_prob"] as? Double
        precStrength = dict["prec_strength"] as? Double
        isThunder = dict["is_thunder"] as? Bool
        
        switch dict["wind_speed"] {
        case let val as Double: windSpeed = Double(val)
        case let val as Double: windSpeed = val
        default: windSpeed = nil
        }
        
        windDir = dict["wind_dir"] as? WindDir
        pressureMm = dict["pressure_mm"] as? Double
        pressurePa = dict["pressure_pa"] as? Double
        humidity = dict["humidity"] as? Double
        daytime = dict["daytime"] as? Daytime
        polar = dict["polar"] as? Bool
        season = dict["season"] as? Season
        source = dict["source"] as? String
        
        let accumPrecDict = dict["accum_prec"] as? [String:Any?]
        accumPrec = AccumPrec(accumPrecDict)
        
        soilMoisture = dict["soil_moisture"] as? Double
        soilTemp = dict["soil_temp"] as? Double
        uvIndex = dict["uv_index"] as? Double
        windGust = dict["wind_gust"] as? Double
    }
    
    private enum CodingKeys: String, CodingKey {
        case obsTime = "obs_time"
        case uptime = "uptime"
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempWater = "temp_water"
        case icon = "icon"
        case condition = "condition"
        case cloudness = "cloudness"
        case precType = "prec_type"
        case precProb = "prec_prob"
        case precStrength = "prec_strength"
        case isThunder = "is_thunder"
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case pressurePa = "pressure_pa"
        case humidity = "humidity"
        case daytime = "daytime"
        case polar = "polar"
        case season = "season"
        case source = "source"
        case accumPrec = "accum_prec"
        case soilMoisture = "soil_moisture"
        case soilTemp = "soil_temp"
        case uvIndex = "uv_index"
        case windGust = "wind_gust"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            obsTime = try values.decodeIfPresent(Double.self, forKey: .obsTime)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .obsTime) {
                obsTime = Double(value)
            } else {
                obsTime = nil
            }
        }
        do {
            uptime = try values.decodeIfPresent(Double.self, forKey: .uptime)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .uptime) {
                uptime = Double(value)
            } else {
                uptime = nil
            }
        }
        do {
            temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .temp) {
                temp = Double(value)
            } else {
                temp = nil
            }
        }
        do {
            feelsLike = try values.decodeIfPresent(Double.self, forKey: .feelsLike)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .feelsLike) {
                feelsLike = Double(value)
            } else {
                feelsLike = nil
            }
        }
        do {
            tempWater = try values.decodeIfPresent(Double.self, forKey: .tempWater)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .tempWater) {
                tempWater = Double(value)
            } else {
                tempWater = nil
            }
        }
        
        do {
            icon = try values.decodeIfPresent(Icon.self, forKey: .icon)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(String.self, forKey: .icon) {
                icon = Icon(rawValue: value)
            } else {
                icon = nil
            }
        }
        
        do {
            condition = try values.decodeIfPresent(Condition.self, forKey: .condition)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(String.self, forKey: .icon) {
                condition = .init(rawValue: value)
            } else {
                condition = nil
            }
        }
        
        do {
            cloudness = try values.decodeIfPresent(Double.self, forKey: .cloudness)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .cloudness) {
                cloudness = Double(value)
            } else {
                cloudness = nil
            }
        }
        
        do {
            precType = try values.decodeIfPresent(Double.self, forKey: .precType)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .precType) {
                precType = Double(value)
            } else {
                precType = nil
            }
        }
        do {
            precProb = try values.decodeIfPresent(Double.self, forKey: .precProb)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .precProb) {
                precProb = Double(value)
            } else {
                precProb = nil
            }
        }
        do {
            precStrength = try values.decodeIfPresent(Double.self, forKey: .precStrength)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .precStrength) {
                precStrength = Double(value)
            } else {
                precStrength = nil
            }
        }
        
        isThunder = try values.decodeIfPresent(Bool.self, forKey: .isThunder)
        
        do {
            windSpeed = try values.decodeIfPresent(Double.self, forKey: .windSpeed)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .windSpeed) {
                windSpeed = Double(value)
            } else {
                windSpeed = nil
            }
        }
        
        do {
            windDir = try values.decodeIfPresent(WindDir.self, forKey: .windDir)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(WindDir.self, forKey: .pressureMm) {
                windDir = WindDir(rawValue: value.rawValue)
            } else {
                windDir = nil
            }
        }
        
        do {
            pressureMm = try values.decodeIfPresent(Double.self, forKey: .pressureMm)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .pressureMm) {
                pressureMm = Double(value)
            } else {
                pressureMm = nil
            }
        }
        
        do {
            pressurePa = try values.decodeIfPresent(Double.self, forKey: .pressurePa)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .pressurePa) {
                pressurePa = Double(value)
            } else {
                pressurePa = nil
            }
        }
        do {
            humidity = try values.decodeIfPresent(Double.self, forKey: .humidity)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .humidity) {
                humidity = Double(value)
            } else {
                humidity = nil
            }
        }
        
        do {
            daytime = try values.decodeIfPresent(Daytime.self, forKey: .daytime)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(String.self, forKey: .daytime) {
                daytime = .init(rawValue: value)
            } else {
                daytime = nil
            }
        }
        
        polar = try values.decodeIfPresent(Bool.self, forKey: .polar)
        season = try values.decodeIfPresent(Season.self, forKey: .season)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        
        do {
            accumPrec = try values.decodeIfPresent(AccumPrec.self, forKey: .accumPrec)
        } catch DecodingError.typeMismatch {
            let value = try values.decodeIfPresent([String:Double].self, forKey: .accumPrec)
            accumPrec = AccumPrec(value)
        }
        
        do {
            soilMoisture = try values.decodeIfPresent(Double.self, forKey: .soilMoisture)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .soilMoisture) {
                soilMoisture = Double(value)
            } else {
                soilMoisture = nil
            }
        }
        
        do {
            soilTemp = try values.decodeIfPresent(Double.self, forKey: .soilTemp)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .soilTemp) {
                soilTemp = Double(value)
            } else {
                soilTemp = nil
            }
        }
        
        do {
            uvIndex = try values.decodeIfPresent(Double.self, forKey: .uvIndex)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .uvIndex) {
                uvIndex = Double(value)
            } else {
                uvIndex = nil
            }
        }
        do {
            windGust = try values.decodeIfPresent(Double.self, forKey: .windGust)
        } catch DecodingError.typeMismatch {
            if let value = try values.decodeIfPresent(Int.self, forKey: .windGust) {
                windGust = Double(value)
            } else {
                windGust = nil
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(obsTime, forKey: .obsTime)
        try container.encodeIfPresent(uptime, forKey: .uptime)
        try container.encodeIfPresent(temp, forKey: .temp)
        try container.encodeIfPresent(feelsLike, forKey: .feelsLike)
        try container.encodeIfPresent(tempWater, forKey: .tempWater)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encodeIfPresent(condition, forKey: .condition)
        try container.encodeIfPresent(cloudness, forKey: .cloudness)
        try container.encodeIfPresent(precType, forKey: .precType)
        try container.encodeIfPresent(precProb, forKey: .precProb)
        try container.encodeIfPresent(precStrength, forKey: .precStrength)
        try container.encodeIfPresent(isThunder, forKey: .isThunder)
        try container.encodeIfPresent(windSpeed, forKey: .windSpeed)
        try container.encodeIfPresent(windDir, forKey: .windDir)
        try container.encodeIfPresent(pressureMm, forKey: .pressureMm)
        try container.encodeIfPresent(pressurePa, forKey: .pressurePa)
        try container.encodeIfPresent(humidity, forKey: .humidity)
        try container.encodeIfPresent(daytime, forKey: .daytime)
        try container.encodeIfPresent(polar, forKey: .polar)
        try container.encodeIfPresent(season, forKey: .season)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(accumPrec, forKey: .accumPrec)
        try container.encodeIfPresent(soilMoisture, forKey: .soilMoisture)
        try container.encodeIfPresent(soilTemp, forKey: .soilTemp)
        try container.encodeIfPresent(uvIndex, forKey: .uvIndex)
        try container.encodeIfPresent(windGust, forKey: .windGust)
    }
}

extension Fact {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["obs_time"] = obsTime
        jsonDict["uptime"] = uptime
        jsonDict["temp"] = temp
        jsonDict["feels_like"] = feelsLike
        jsonDict["temp_water"] = tempWater
        jsonDict["icon"] = icon
        jsonDict["condition"] = condition
        jsonDict["cloudness"] = cloudness
        jsonDict["prec_type"] = precType
        jsonDict["prec_prob"] = precProb
        jsonDict["prec_strength"] = precStrength
        jsonDict["is_thunder"] = isThunder
        jsonDict["wind_speed"] = windSpeed
        jsonDict["wind_dir"] = windDir
        jsonDict["pressure_mm"] = pressureMm
        jsonDict["pressure_pa"] = pressurePa
        jsonDict["humidity"] = humidity
        jsonDict["daytime"] = daytime
        jsonDict["polar"] = polar
        jsonDict["season"] = season
        jsonDict["source"] = source
        jsonDict["accum_prec"] = accumPrec?.toDictionary()
        jsonDict["soil_moisture"] = soilMoisture
        jsonDict["soil_temp"] = soilTemp
        jsonDict["uv_index"] = uvIndex
        jsonDict["wind_gust"] = windGust
        return jsonDict
    }
}
