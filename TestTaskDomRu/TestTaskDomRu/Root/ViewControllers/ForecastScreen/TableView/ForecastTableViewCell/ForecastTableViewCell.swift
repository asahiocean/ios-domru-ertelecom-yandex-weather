import UIKit

typealias Cell = ForecastTableViewCell
class ForecastTableViewCell: UITableViewCell {
    
    public static let reuseId = "ForecastTableViewCell"
    
    @IBOutlet private weak var dateOfMonthLabel: UILabel!
    @IBOutlet private weak var dayOfWeekLabel: UILabel!
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var imageViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var daytimeTempLabel: UILabel!
    @IBOutlet private weak var nightTempLabel: UILabel!
    
    func config(with model: TableViewCellModel) {
        DispatchQueue.main.async { [self] in
            autoreleasepool {
                imageViewHeight.constant = (daytimeTempLabel.font.pointSize * 1.5)
                dateOfMonthLabel.text = model.dateOfMonth
                dayOfWeekLabel.text = model.dayOfWeek
                iconImageView.image = model.conditionImage
                daytimeTempLabel.text = model.dayTemp
                nightTempLabel.text = model.nightTemp
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
