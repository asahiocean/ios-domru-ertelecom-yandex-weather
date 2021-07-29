import UIKit

final class ForecastPresenter: ForecastInteractorDelegate {
    
    // MARK: - Private properties -
    
    private unowned let view: ForecastViewInterface
    private let interactor: ForecastInteractorInterface
    private let wireframe: ForecastWireframeInterface
    
    private func startConfirure() {
        interactor.delegate = self
    }
    
    func updateNotify() {
        // Update with a slight delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.view.reloadData()
        })
    }
    
    // MARK: - Lifecycle -
    
    init(view: ForecastViewInterface, interactor: ForecastInteractorInterface, wireframe: ForecastWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        startConfirure()
    }
}

// MARK: - Extensions -

extension ForecastPresenter: ForecastPresenterInterface {
    
    func floatingViewContent() -> (image: UIImage?, text: String) {
        let image = Image("wavingHand")
        let text = "🔥 GOOD LUCK 🔥"
        return (image: image, text: text)
    }
    
    func heightForRowAt(at indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        default:
            return 60
        }
    }
    
    func floatingViewRotation() -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0.0
        rotation.toValue = CGFloat.pi / 2
        rotation.duration = 0.3
        rotation.autoreverses = true
        rotation.repeatCount = .infinity
        return rotation
    }
    
    func floatingViewShake() -> CAKeyframeAnimation {
        interactor.floatingViewClicked()
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = .init(name: .linear)
        animation.duration = 0.6
        animation.values = [-20,20,-20,20,-10,10,-5,5,0]
        return animation
    }
    
    func collectionViewCreate(_ completion: @escaping ((UICollectionView) -> ())) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(Zero.nib, forCellWithReuseIdentifier: Zero.reuseId)
        collectionView.register(One.nib, forCellWithReuseIdentifier: One.reuseId)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        completion(collectionView)
    }
    
    fileprivate func viewSetTitle() {
        interactor.localityName({ [unowned view] in
            view.setTitle(with: $0)
        })
    }
    
    // MARK: - Lifecycle -
    
    func viewDidLoad() {
        view.setupView()
        viewSetTitle()
    }
    
    func viewWillAppear(animated: Bool) {
        viewUpdate()
    }
    
    fileprivate func viewUpdate() {
        interactor.factTemp({ [unowned view] in
            view.factTemp(value: $0)
        })
        interactor.factFeelsLike({ [unowned view] in
            view.factFeelsLike(text: $0)
        })
        interactor.factCondition({ [unowned view] in
            view.factCondition(text: $0)
        })
    }
    
    // MARK: - Collection View: Forecast -
    
    final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    final func numberOfItems(in section: Int) -> Int {
        switch section {
        case 0: // wind_speed + pressure_mm + humidity
            return 1
        case 1: // hourly forecast
            return 20
        default:
            fatalError("Unknown section!")
        }
    }
    
    final func sizeForItemAt(at indexPath: IndexPath, in bounds: CGRect) -> CGSize {
        switch indexPath.section {
        case let section:
            switch section {
            case 0:
                let w = bounds.width / 2.5
                return CGSize(width: w, height: bounds.height)
            case 1:
                let w = bounds.width / 5
                return CGSize(width: w, height: bounds.height)
            default:
                fatalError("Unknown section!")
            }
        }
    }
    
    final func cellForItemAt(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell {
        func dequeueReusableCell<T:UICollectionViewCell>(_ collectionView: UICollectionView, _ index: IndexPath) -> T {
            collectionView.dequeueReusableCell(withReuseIdentifier: T.id, for: index) as! T
        }
        switch indexPath.section {
        case let section:
            switch section {
            case 0:
                let cell: Zero = dequeueReusableCell(collectionView, indexPath)
                interactor.zeroSection { cell.config(with: $0) }
                return cell
            case 1:
                let cell: One = dequeueReusableCell(collectionView, indexPath)
                interactor.oneSection(at: indexPath, { cell.config(with: $0) })
                return cell
            default:
                fatalError("Unknown section!")
            }
        }
    }
    
    final func insetForSection(at section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    // MARK: - TableView -
    
    final func numberOfSections() -> Int {
        return 1
    }
    
    final func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0:
            return interactor.forecastsCount()
        default:
            fatalError()
        }
    }
    
    final func cellForRow(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as! Cell
        let index = indexPath.row
        if let model = interactor.tenDaysForecast(for: index) {
            cell.config(with: model)
        }
        return cell
    }
    
    final func didSelectRow(at indexPath: IndexPath) {
        interactor.didSelectRow(at: indexPath, {
            self.wireframe.forecast(with: $0, date: $1)
        })
    }
}
