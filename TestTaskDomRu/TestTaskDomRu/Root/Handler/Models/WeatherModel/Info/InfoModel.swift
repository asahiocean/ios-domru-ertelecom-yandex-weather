import Foundation

typealias Info = InfoModel

/// https://yandex.ru/dev/weather/doc/dg/concepts/forecast-test.html#resp-format__info
struct InfoModel: Codable {
    
    let n: Bool?
    let geoid: Double?
    let url: String?
    let lat: Double?
    let lon: Double?
    let tzinfo: TZinfo?
    let defPressureMm: Double?
    let defPressurePa: Double?
    let slug: String?
    let zoom: Double?
    let nr: Bool?
    let ns: Bool?
    let nsr: Bool?
    let p: Bool?
    let f: Bool?
    let h: Bool?
    
    internal init(n: Bool? = nil,
                  geoid: Double? = nil,
                  url: String? = nil,
                  lat: Double? = nil,
                  lon: Double? = nil,
                  tzinfo: TZinfo? = nil,
                  defPressureMm: Double? = nil,
                  defPressurePa: Double? = nil,
                  slug: String? = nil,
                  zoom: Double? = nil,
                  nr: Bool? = nil,
                  ns: Bool? = nil,
                  nsr: Bool? = nil,
                  p: Bool? = nil,
                  f: Bool? = nil,
                  h: Bool? = nil) {
        self.n = n
        self.geoid = geoid
        self.url = url
        self.lat = lat
        self.lon = lon
        self.tzinfo = tzinfo
        self.defPressureMm = defPressureMm
        self.defPressurePa = defPressurePa
        self.slug = slug
        self.zoom = zoom
        self.nr = nr
        self.ns = ns
        self.nsr = nsr
        self.p = p
        self.f = f
        self.h = h
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        n = dict["n"] as? Bool
        geoid = dict["geoid"] as? Double
        url = dict["url"] as? String
        lat = dict["lat"] as? Double
        lon = dict["lon"] as? Double
        
        let tzinfoDict = dict["tzinfo"] as? [String:Any?]
        tzinfo = TZinfo(tzinfoDict)
        
        defPressureMm = dict["def_pressure_mm"] as? Double
        defPressurePa = dict["def_pressure_pa"] as? Double
        slug = dict["slug"] as? String
        zoom = dict["zoom"] as? Double
        nr = dict["nr"] as? Bool
        ns = dict["ns"] as? Bool
        nsr = dict["nsr"] as? Bool
        p = dict["p"] as? Bool
        f = dict["f"] as? Bool
        h = dict["_h"] as? Bool
    }
    
    private enum CodingKeys: String, CodingKey {
        case n = "n"
        case geoid = "geoid"
        case url = "url"
        case lat = "lat"
        case lon = "lon"
        case tzinfo = "tzinfo"
        case defPressureMm = "def_pressure_mm"
        case defPressurePa = "def_pressure_pa"
        case slug = "slug"
        case zoom = "zoom"
        case nr = "nr"
        case ns = "ns"
        case nsr = "nsr"
        case p = "p"
        case f = "f"
        case h = "_h"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        n = try values.decodeIfPresent(Bool.self, forKey: .n)
        geoid = try values.decodeIfPresent(Double.self, forKey: .geoid)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
        tzinfo = try values.decodeIfPresent(TZinfo.self, forKey: .tzinfo)
        defPressureMm = try values.decodeIfPresent(Double.self, forKey: .defPressureMm)
        defPressurePa = try values.decodeIfPresent(Double.self, forKey: .defPressurePa)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        zoom = try values.decodeIfPresent(Double.self, forKey: .zoom)
        nr = try values.decodeIfPresent(Bool.self, forKey: .nr)
        ns = try values.decodeIfPresent(Bool.self, forKey: .ns)
        nsr = try values.decodeIfPresent(Bool.self, forKey: .nsr)
        p = try values.decodeIfPresent(Bool.self, forKey: .p)
        f = try values.decodeIfPresent(Bool.self, forKey: .f)
        h = try values.decodeIfPresent(Bool.self, forKey: .h)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(n, forKey: .n)
        try container.encodeIfPresent(geoid, forKey: .geoid)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(lat, forKey: .lat)
        try container.encodeIfPresent(lon, forKey: .lon)
        try container.encodeIfPresent(tzinfo, forKey: .tzinfo)
        try container.encodeIfPresent(defPressureMm, forKey: .defPressureMm)
        try container.encodeIfPresent(defPressurePa, forKey: .defPressurePa)
        try container.encodeIfPresent(slug, forKey: .slug)
        try container.encodeIfPresent(zoom, forKey: .zoom)
        try container.encodeIfPresent(nr, forKey: .nr)
        try container.encodeIfPresent(ns, forKey: .ns)
        try container.encodeIfPresent(nsr, forKey: .nsr)
        try container.encodeIfPresent(p, forKey: .p)
        try container.encodeIfPresent(f, forKey: .f)
        try container.encodeIfPresent(h, forKey: .h)
    }
}

extension InfoModel {
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["n"] = n
        jsonDict["geoid"] = geoid
        jsonDict["url"] = url
        jsonDict["lat"] = lat
        jsonDict["lon"] = lon
        jsonDict["tzinfo"] = tzinfo?.toDictionary()
        jsonDict["def_pressure_mm"] = defPressureMm
        jsonDict["def_pressure_pa"] = defPressurePa
        jsonDict["slug"] = slug
        jsonDict["zoom"] = zoom
        jsonDict["nr"] = nr
        jsonDict["ns"] = ns
        jsonDict["nsr"] = nsr
        jsonDict["p"] = p
        jsonDict["f"] = f
        jsonDict["_h"] = h
        return jsonDict
    }
}
