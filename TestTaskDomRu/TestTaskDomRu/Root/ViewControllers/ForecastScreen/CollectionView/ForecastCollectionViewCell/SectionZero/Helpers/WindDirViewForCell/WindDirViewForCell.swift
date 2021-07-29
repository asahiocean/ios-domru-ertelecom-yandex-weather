import Foundation
import UIKit.UIView

open class WindDirViewForCell: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var arrowLabelView: UILabel!
    
    // Function for turning the arrow that indicates the wind direction
    private func rotate(to degree: CGFloat) {
        let transform = CGAffineTransform(rotationAngle: degree)
        UIView.animate(withDuration: 0, animations: { [self] in
            arrowLabelView.transform = transform
            arrowLabelView.layoutIfNeeded()
        })
    }
    
    func setDegrees(with value: Double?) {
        if let value = value {
            rotate(to: CGFloat(value))
        } else {
            // ...
        }
    }
    
    private func commonInit() {
        let bundle = Bundle(for: Self.self)
        bundle.loadNibNamed("WindDirViewForCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,
                                        .flexibleHeight]
        // Turn the arrow to the vertical position (as on the clock)
        rotate(to: .zero * .pi/180)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
