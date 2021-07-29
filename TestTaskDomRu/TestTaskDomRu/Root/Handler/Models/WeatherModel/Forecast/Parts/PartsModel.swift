import Foundation

typealias Parts = PartsModel
struct PartsModel: Codable {
    
    let nightShort: NightShort?
    let dayShort: DayShort?
    let night: Night?
    let day: Day?
    let evening: Evening?
    let morning: Morning?
    
    internal init(nightShort: NightShort? = nil,
                  dayShort: DayShort? = nil,
                  night: Night? = nil,
                  day: Day? = nil,
                  evening: Evening? = nil,
                  morning: Morning? = nil) {
        self.nightShort = nightShort
        self.dayShort = dayShort
        self.night = night
        self.day = day
        self.evening = evening
        self.morning = morning
    }
    
    internal init?(_ dict: [String: Any?]?) {
        guard let dict = dict else { return nil }
        let eveningDict = dict["evening"] as? [String:Any?]
        evening = Evening(eveningDict)
        
        let morningDict = dict["morning"] as? [String:Any?]
        morning = Morning(morningDict)
        
        let nightShortDict = dict["night_short"] as? [String:Any?]
        nightShort = NightShort(nightShortDict)
        
        let dayShortDict = dict["day_short"] as? [String:Any?]
        dayShort = DayShort(dayShortDict)
        
        let nightDict = dict["night"] as? [String:Any?]
        night = Night(nightDict)
        
        let dayDict = dict["day"] as? [String:Any?]
        day = Day(dayDict)
    }
    
    private enum CodingKeys: String, CodingKey {
        case nightShort = "night_short"
        case dayShort = "day_short"
        case night = "night"
        case day = "day"
        case evening = "evening"
        case morning = "morning"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nightShort = try values.decodeIfPresent(NightShort.self, forKey: .nightShort)
        dayShort = try values.decodeIfPresent(DayShort.self, forKey: .dayShort)
        night = try values.decodeIfPresent(Night.self, forKey: .night)
        day = try values.decodeIfPresent(Day.self, forKey: .day)
        evening = try values.decodeIfPresent(Evening.self, forKey: .evening)
        morning = try values.decodeIfPresent(Morning.self, forKey: .morning)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(nightShort, forKey: .nightShort)
        try container.encodeIfPresent(dayShort, forKey: .dayShort)
        try container.encodeIfPresent(night, forKey: .night)
        try container.encodeIfPresent(day, forKey: .day)
        try container.encodeIfPresent(evening, forKey: .evening)
        try container.encodeIfPresent(morning, forKey: .morning)
    }
}

extension Parts {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["evening"] = evening?.toDictionary()
        jsonDict["morning"] = morning?.toDictionary()
        jsonDict["night_short"] = nightShort?.toDictionary()
        jsonDict["day_short"] = dayShort?.toDictionary()
        jsonDict["night"] = night?.toDictionary()
        jsonDict["day"] = day?.toDictionary()
        return jsonDict
    }
}

/*
 Прогнозы по времени суток и 12-часовые прогнозы.
 
 Содержит поля, различающиеся типом прогноза:
 
 night — прогноз на ночь.
 morning — прогноз на утро.
 day — прогноз на день.
 evening — прогноз на вечер.
 day_short — 12-часовой прогноз на день.
 night_short — прогноз на ночь, для которого исключены поля temp_min и temp_max, в поле temp указывается минимальная температура за ночной период.
 
 Все прогнозы погоды на время суток имеют одинаковый набор полей.
 
 Все 12-часовые прогнозы имеют одинаковый набор полей.
 
 Примечание. В последнем возвращаемом дне прогноза состав частей может быть неполным.
 
 */
