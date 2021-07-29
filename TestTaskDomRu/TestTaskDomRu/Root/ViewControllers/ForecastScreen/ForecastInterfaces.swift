import UIKit

protocol ForecastWireframeInterface: WireframeInterface {
    func forecast(with model: Forecast, date: String)
}

protocol ForecastViewInterface: ViewInterface {
    func setupView()
    func setTitle(with text: String)
    func reloadData()
    
    // MARK: - Fact Temperature (Header) -
    func factTemp(value: String)
    func factFeelsLike(text: String)
    func factCondition(text: String)
}

protocol ForecastPresenterInterface: PresenterInterface {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    
    func floatingViewContent() -> (image: UIImage?, text: String)
    func floatingViewRotation() -> CABasicAnimation
    func floatingViewShake() -> CAKeyframeAnimation
    
    // MARK: - CollectionView: Forecast -
    func collectionViewCreate(_ completion: @escaping ((UICollectionView)->()))
    func numberOfSections(in collectionView: UICollectionView) -> Int
    func numberOfItems(in section: Int) -> Int
    func cellForItemAt(at indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    func sizeForItemAt(at indexPath: IndexPath, in bounds: CGRect) -> CGSize
    func insetForSection(at section: Int) -> UIEdgeInsets
    
    // MARK: - TableView -
    func heightForRowAt(at indexPath: IndexPath) -> CGFloat
    func numberOfRows(in section: Int) -> Int
    func numberOfSections() -> Int
    func cellForRow(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
    func didSelectRow(at indexPath: IndexPath)
}

protocol ForecastInteractorInterface: InteractorInterface {
    var delegate: ForecastInteractorDelegate? { get set }
    func localityName(_ completion: @escaping ((String)->()))
    func floatingViewClicked()
    
    // MARK: - Fact Temperature (Header) -
    func factTemp(_ completion: @escaping ((String)->()))
    func factFeelsLike(_ completion: @escaping ((String)->()))
    func factCondition(_ completion: @escaping ((String)->()))
    
    // MARK: - CollectionView: Forecast -
    func zeroSection(_ completion: @escaping ((ZeroSectionModel)->()))
    func oneSection(at indexPath: IndexPath, _ completion: @escaping ((OneSectionModel)->()))
    
    // MARK: - TableView -
    func forecastsCount() -> Int
    func tenDaysForecast(for index: Int) -> TableViewCellModel?
    func didSelectRow(at indexPath: IndexPath, _ completion: @escaping ((_ model: Forecast, _ date: String)->()))
}
