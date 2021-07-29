import Foundation
import UIKit.UIImage

protocol TableViewCellModelProtocol {
    var dateOfMonth: String { get }
    var dayOfWeek: String { get }
    var conditionImage: UIImage { get }
    var dayTemp: String { get }
    var nightTemp: String { get }
}

struct TableViewCellModel: TableViewCellModelProtocol {
    let dateOfMonth: String
    let dayOfWeek: String
    let conditionImage: UIImage
    let dayTemp: String
    let nightTemp: String
    
    internal init(ddMM dateOfMonth: String,
                  wd dayOfWeek: String,
                  icon conditionImage: UIImage,
                  tmax dayTemp: String,
                  tmin nightTemp: String) {
        self.dateOfMonth = dateOfMonth
        self.dayOfWeek = dayOfWeek
        self.conditionImage = conditionImage
        self.dayTemp = dayTemp
        self.nightTemp = nightTemp
    }
}
