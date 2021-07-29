import UIKit

class FactTempView: UIView {
    
    var isInterfaceBuilder: Bool = false
    
    @IBOutlet private weak var tempLabel: UILabel!
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var conditionView: UIView!
    
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var conditionImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var conditionLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    
    func factTemp(with text: String) {
        DispatchQueue.main.async {
            self.tempLabel.text = text
        }
    }
    
    func factCondition(with text: String) {
        DispatchQueue.main.async {
            self.conditionLabel.text = text
        }
    }
    
    func factFeelsLike(with text: String) {
        DispatchQueue.main.async {
            self.feelsLikeLabel.text = text
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = tempLabel.font.pointSize * 1.1
        conditionImageViewHeight.constant = height
    }
    
    private func commonInit() {
        let bundle = Bundle(for: FactTempView.self)
        bundle.loadNibNamed(FactTempView.id, owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.isInterfaceBuilder = true
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
}
