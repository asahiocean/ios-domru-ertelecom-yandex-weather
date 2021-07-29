import Foundation

typealias GeoObject = GeoObjectModel
struct GeoObjectModel: Codable {
    
    let district: District?
    let locality: Locality?
    let province: Province?
    let country: Country?
    
    private enum CodingKeys: String, CodingKey {
        case district = "district"
        case locality = "locality"
        case province = "province"
        case country = "country"
    }
    
    internal init(district: District? = nil,
                  locality: Locality? = nil,
                  province: Province? = nil,
                  country: Country? = nil) {
        self.district = district
        self.locality = locality
        self.province = province
        self.country = country
    }
    
    internal init?(_ dict: [String:Any?]?) {
        guard let dict = dict else { return nil }
        let districtDict = dict["district"] as? [String:Any?]
        district = District(districtDict)
        
        let localityDict = dict["locality"] as? [String:Any?]
        locality = Locality(localityDict)
        
        let provinceDict = dict["province"] as? [String:Any?]
        province = Province(provinceDict)
        
        let countryDict = dict["country"] as? [String:Any?]
        country = Country(countryDict)
    }
    
    func toDictionary() -> [String:Any?] {
        var jsonDict = [String:Any?]()
        jsonDict["district"] = district?.toDictionary()
        jsonDict["locality"] = locality?.toDictionary()
        jsonDict["province"] = province?.toDictionary()
        jsonDict["country"] = country?.toDictionary()
        return jsonDict
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        district = try values.decodeIfPresent(District.self, forKey: .district)
        locality = try values.decodeIfPresent(Locality.self, forKey: .locality)
        province = try values.decodeIfPresent(Province.self, forKey: .province)
        country = try values.decodeIfPresent(Country.self, forKey: .country)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(district, forKey: .district)
        try container.encodeIfPresent(locality, forKey: .locality)
        try container.encodeIfPresent(province, forKey: .province)
        try container.encodeIfPresent(country, forKey: .country)
    }
}
