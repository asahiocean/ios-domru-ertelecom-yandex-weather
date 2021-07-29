import UIKit

typealias One = ForecastCollectionViewCellSectionOne

/// Cells for displaying weather information in the first section (not zero)
class ForecastCollectionViewCellSectionOne: UICollectionViewCell {
    
    public static let reuseId: String = "ForecastCollectionViewCellSectionOne"
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    
    func config(with model: OneSectionModel) {
        self.timeLabel.text = model.time
        self.iconImageView.image = model.image
        self.tempLabel.text = model.temp
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
