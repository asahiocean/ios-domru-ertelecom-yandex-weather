import UIKit

typealias PartCell = PartForecastTableViewCell
/*
    Стоило сделать модель для отображения вьюхи и
    нагенерить их, а потом раскидать по стеквью
    Походу мозги уже кипели когда это делал
*/
class PartForecastTableViewCell: UITableViewCell {
    
    public static let reuseId = "PartForecastTableViewCell"
    
    @IBOutlet private weak var mainStackView: UIStackView!
    
    // MARK:  - Header Stack View -
    @IBOutlet private weak var headerStackView: UIStackView!
    
    @IBOutlet private weak var morningStackView: UIStackView!
    @IBOutlet private weak var morningLabel: UILabel!
    @IBOutlet private weak var morningValue: UILabel!
    @IBOutlet private weak var morningSecondValue: UILabel!
    @IBOutlet private weak var morningView: UIView!
    @IBOutlet private weak var morningImageView: UIImageView!
    
    @IBOutlet private weak var dayStackView: UIStackView!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dayValue: UILabel!
    @IBOutlet private weak var dayView: UIView!
    @IBOutlet private weak var dayImageView: UIImageView!
    @IBOutlet private weak var daySecondValue: UILabel!
    
    @IBOutlet private weak var eveningStackView: UIStackView!
    @IBOutlet private weak var eveningLabel: UILabel!
    @IBOutlet private weak var eveningValue: UILabel!
    @IBOutlet private weak var eveningSecondValue: UILabel!
    @IBOutlet private weak var eveningView: UIView!
    @IBOutlet private weak var eveningImageView: UIImageView!
    
    @IBOutlet private weak var nightStackView: UIStackView!
    @IBOutlet private weak var nightLabel: UILabel!
    @IBOutlet private weak var nightValue: UILabel!
    @IBOutlet private weak var nightSecondValue: UILabel!
    @IBOutlet private weak var nightView: UIView!
    @IBOutlet private weak var nightImageView: UIImageView!
    
    
    // MARK:  - Footer Stack View -
    @IBOutlet private weak var footerStackView: UIStackView!
    @IBOutlet private weak var footerTopView: UIView!
    @IBOutlet private weak var footerLabel: UILabel!
    @IBOutlet private weak var footerContentStackView: UIStackView!
    
    func config(dict: [String:[String:PartForecastModel]]) {
        for (key,value) in dict {
            switch key {
            case "Температура": temp(value)
            case "Ветер": wind(value)
            case "Влажность": humidity(value)
            case "Давление": pressure(value)
            default: fatalError()
            }
        }
    }
    
    private func temp(_ dict: [String:PartForecastModel]) {
        for index in dict.keys.indices {
            let key = dict.keys[index]
            let value = dict.values[index]
            let _temp = value.temp,
                image = _temp.conditionIcon,
                temp = _temp.temp,
                fl = _temp.tempFeelslike
            handler(key, { [self] in // morningCompletion
                morningImageView.image = image
                morningValue.text = temp
                morningSecondValue.text  = fl
            }, { [self] in // dayCompletion
                dayImageView.image = image
                dayValue.text = temp
                daySecondValue.text  = fl
            }, { [self] in // eveningCompletion
                eveningImageView.image = image
                eveningValue.text = temp
                eveningSecondValue.text  = fl
            }, { [self] in // nightCompletion
                nightImageView.image = image
                nightValue.text = temp
                nightSecondValue.text  = fl
            })
        }
    }
    
    private func wind(_ dict: [String:PartForecastModel]) {
        hiddenImageView()
        footerLabel.text = "Направление ветра"
        for index in dict.keys.indices {
            let key = dict.keys[index]
            let value = dict.values[index]
            let w = value.wind,
                ws = w.wind_speed,
                wg = w.wind_gust,
                wd = w.wind_dir
            let speed = "\(ws)-\(wg) м/с"
            handler(key, { [self] in // morningCompletion
                morningValue.text = speed
                morningSecondValue.text  = wd
            }, { [self] in // dayCompletion
                dayValue.text = speed
                daySecondValue.text  = wd
            }, { [self] in // eveningCompletion
                eveningValue.text = speed
                eveningSecondValue.text  = wd
            }, { [self] in // nightCompletion
                nightValue.text = speed
                nightSecondValue.text  = wd
            })
        }
    }
    
    private func humidity(_ dict: [String:PartForecastModel]) {
        headerStackView.alignment = .center
        for index in dict.keys.indices {
            let value = dict.values[index].humidity
            extractedFunc(dict.keys[index], value)
        }
    }
    
    private func pressure(_ dict: [String:PartForecastModel]) {
        for index in dict.keys.indices {
            var value = dict.values[index].pressure_mm
            value = String(value.dropLast(6))
            extractedFunc(dict.keys[index], value)
        }
    }
    
    private func extractedFunc(_ key: String, _ value: String) {
        hiddenImageView()
        footerStackView?.removeFromSuperview()
        handler(key, { [self] in
            morningValue.text = value
        }, { [self] in
            dayValue.text = value
        }, { [self] in
            eveningValue.text = value
        }, { [self] in
            nightValue.text = value
        })
    }
    
    private typealias Voids = (()->(Void))
    
    private func handler(_ key: String,
                         _ morningCompletion: @escaping Voids,
                         _ dayCompletion: @escaping Voids,
                         _ eveningCompletion: @escaping Voids,
                         _ nightCompletion: @escaping Voids) {
        switch key {
        case "Утром": morningCompletion()
        case "Днём": dayCompletion()
        case "Вечером": eveningCompletion()
        case "Ночью": nightCompletion()
        default: fatalError()
        }
    }
    
    fileprivate func hiddenImageView(at value: Bool = true) {
        morningView.removeFromSuperview()
        dayView.removeFromSuperview()
        eveningView.removeFromSuperview()
        nightView.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // hiddenImageView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
