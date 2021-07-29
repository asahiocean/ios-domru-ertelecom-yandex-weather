import Foundation

enum Icon: String, Codable, RawRepresentable {
    case bknD = "bkn_d"
    case bknN = "bkn_n"
    case bknRaD = "bkn_ra_d"
    case bknRaN = "bkn_-ra_n"
    case iconBknRaDplus = "bkn_+ra_d"
    case iconBknRaDminus = "bkn_-ra_d"
    case ovc = "ovc"
    case ovcRa = "ovc_ra"
    case iconOvcRa = "ovc_+ra"
    case purpleOvcRa = "ovc_-ra"
    case ovcTs = "ovc_ts"
    case ovcTsRa = "ovc_ts_ra"
    case skcD = "skc_d"
    case skcN = "skc_n"
}

/*
 Описание:
 Код иконки погоды. Иконка доступна по адресу https://yastatic.net/weather/i/icons/blueye/color/svg/<значение из поля icon>.svg.
 
 Формат: Строка
 */
