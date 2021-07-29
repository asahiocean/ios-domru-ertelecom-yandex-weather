import Foundation

/// Wind direction
enum WindDir: String, Codable {
    /// North-West
    case nw = "nw"
    /// Northern
    case n = "n"
    /// North-Eastern
    case ne = "ne"
    /// Eastern
    case e = "e"
    /// South-Eastern
    case se = "se"
    /// Southern
    case s = "s"
    /// Southwest
    case sw = "sw"
    /// Western
    case w = "w"
    /// Calm
    case c = "c"
}

/*
 
 Направление ветра. Возможные значения:
 
 «nw» — северо-западное.
 «n» — северное.
 «ne» — северо-восточное.
 «e» — восточное.
 «se» — юго-восточное.
 «s» — южное.
 «sw» — юго-западное.
 «w» — западное.
 «с» — штиль.
 
 Формат: Строка
 */
