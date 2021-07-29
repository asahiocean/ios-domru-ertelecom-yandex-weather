import UIKit

typealias Zero = ForecastCollectionViewCellSectionZero

/// The display cell of the leftmost cell of the collection (in the zero section)
class ForecastCollectionViewCellSectionZero: UICollectionViewCell {
    
    public static let reuseId: String = "ForecastCollectionViewCellSectionZero"
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var mainStackView: UIStackView!
    
    @IBOutlet private weak var windStackView: UIStackView!
    @IBOutlet private weak var windImageView: UIImageView!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var windDirArrowView: WindDirViewForCell!
    
    @IBOutlet private weak var pressureStackView: UIStackView!
    @IBOutlet private weak var pressureImageView: UIImageView!
    @IBOutlet private weak var pressureLabel: UILabel!
    
    @IBOutlet private weak var humidityStackView: UIStackView!
    @IBOutlet private weak var humidityImageView: UIImageView!
    @IBOutlet private weak var humidityLabel: UILabel!
    
    public func config(with model: ZeroSectionModel) {
        self.windConfigure(model.wind_speed, model.wind_dir)
        self.pressureConfigure(with: model.pressure_mm)
        self.humidityConfigure(with: model.humidity)
    }
    
    private func windConfigure(_ speed: String?,
                               _ direction: (name: String, degrees: Double?)) {
        if let speed = speed {
            windLabel.text = "\(speed), \(direction.name)"
        } else {
            windLabel.text = "штиль"
        }
        windDirArrowView.alpha = speed != nil ? 1 : 0
        windDirArrowView.setDegrees(with: direction.degrees)
    }
    
    private func pressureConfigure(with text: String) {
        pressureLabel.text = text
    }
    
    private func humidityConfigure(with text: String) {
        humidityLabel.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        windImageView.image = Image("wind")
        pressureImageView.image = Image("barometer")
        humidityImageView.image = Image("drop")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
