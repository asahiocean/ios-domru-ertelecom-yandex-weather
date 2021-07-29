import Foundation

typealias Condition = WeatherConditions
enum WeatherConditions: String, Codable {
    case clear = "clear"
    case partlyCloudy = "partly-cloudy"
    case cloudy = "cloudy"
    case overcast = "overcast"
    case drizzle = "drizzle"
    case lightRain = "light-rain"
    case rain = "rain"
    case moderateRain = "moderate-rain"
    case heavyRain = "heavy-rain"
    case continuousHeavyRain = "continuous-heavy-rain"
    case showers = "showers"
    case wetSnow = "wet-snow"
    case lightSnow = "light-snow"
    case snow = "snow"
    case snowShowers = "snow-showers"
    case hail = "hail"
    case thunderstorm = "thunderstorm"
    case thunderstormWithRain = "thunderstorm-with-rain"
    case thunderstormWithHail = "thunderstorm-with-hail"
}

/*
 Код расшифровки погодного описания. Возможные значения:
 
 clear — ясно.
 partly-cloudy — малооблачно.
 cloudy — облачно с прояснениями.
 overcast — пасмурно.
 drizzle — морось.
 light-rain — небольшой дождь.
 rain — дождь.
 moderate-rain — умеренно сильный дождь.
 heavy-rain — сильный дождь.
 continuous-heavy-rain — длительный сильный дождь.
 showers — ливень.
 wet-snow — дождь со снегом.
 light-snow — небольшой снег.
 snow — снег.
 snow-showers — снегопад.
 hail — град.
 thunderstorm — гроза.
 thunderstorm-with-rain — дождь с грозой.
 thunderstorm-with-hail — гроза с градом.
 
 */
