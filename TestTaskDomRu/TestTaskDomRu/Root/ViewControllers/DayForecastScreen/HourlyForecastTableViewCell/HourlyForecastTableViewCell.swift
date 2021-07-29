import UIKit

typealias HourCell = HourlyForecastTableViewCell

/// Cell for displaying the hourly forecast
class HourlyForecastTableViewCell: UITableViewCell {
    
    public static let reuseId = "HourlyForecastTableViewCell"
    
    @IBOutlet private weak var timeLabel: UILabel!
    
    // MARK: - Temp -
    
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var conditionImageView: UIImageView!
    
    // MARK: - Wind -
    
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var windImageView: UIImageView!
    
    // MARK: - Humidity -
    
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var humidityImageView: UIImageView!
    
    // MARK: - Pressure -
    
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var pressureImageView: UIImageView!
    
    public func forecast(with model: HourlyForecastModel) {
        DispatchQueue.main.async { [self] in
            autoreleasepool {
                timeLabel.text = model.time
                tempLabel.text = model.temp
                conditionImageView.image = model.conditionImage
                windSpeedLabel.text = model.windSpeed
                humidityLabel.text = model.humidity
                pressureLabel.text = model.pressure
                fillColorConfig(with: !(model.time.contains("0")))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        conditionImageView.image = Image("partly-cloudy-icon")
        windImageView.image = Image("wind")
        humidityImageView.image = Image("drop")
        pressureImageView.image = Image("barometer")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

fileprivate extension HourlyForecastTableViewCell {
    private func fillColorConfig(with condition: Bool) {
        switch condition {
        case true:
            let color = UIColor(hex: "#99CCFF")
            backgroundColor = color.withAlphaComponent(0.3)
        default:
            if #available(iOS 13.0, *) {
                backgroundColor = .systemBackground
            } else {
                backgroundColor = .white
            }
        }
    }
}
