import UIKit

class FloatingView: UIView {
    
    @IBOutlet private(set) weak var contentView: UIView!
    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var textLabel: UILabel!
    
    var isInterfaceBuilder: Bool = false
    
    public func config(_ image: UIImage?, _ text: String) {
        DispatchQueue.main.async { [self] in
            if let image = image {
                imageView?.image = image
            } else {
                imageView?.removeFromSuperview()
            }
            textLabel?.text = text
        }
    }
    
    fileprivate func commonInit() {
        let bundle = Bundle(for: Self.self)
        bundle.loadNibNamed(Self.id, owner: self, options: nil)
        addSubview(contentView)
        viewFillConstraints(with: contentView)
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

fileprivate extension FloatingView {
    private func viewFillConstraints(with view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
