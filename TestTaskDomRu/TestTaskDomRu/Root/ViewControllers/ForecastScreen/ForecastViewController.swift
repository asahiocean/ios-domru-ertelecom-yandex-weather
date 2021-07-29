import UIKit

final class ForecastViewController: UIViewController {
    
    // MARK: - Public properties -
    
    var presenter: ForecastPresenterInterface!
    
    // MARK: - IBOutlet -
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var factTempView: FactTempView! // Header
    
    @IBOutlet private weak var updateTimeLabel: UILabel!
    
    // MARK: Forecasts
    @IBOutlet private weak var hourlyForecastView: UIView!
    private weak var collectionViewHourlyForecast: UICollectionView!
    @IBOutlet private weak var floatingView: FloatingView!
    @IBOutlet private weak var tableView: ContentSizedTableView!
    
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        floatingViewConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        floatingViewRotation()
        presenter.viewWillAppear(animated: animated)
    }
}

private extension ForecastViewController {
    
    func floatingViewConfigure() {
        guard let fv = floatingView else { return }
        let content = presenter.floatingViewContent()
        fv.config(content.image,content.text)
        fv.backgroundColor = .init(hex: "#9EFFAD")
        fv.layer.cornerRadius = 10
        fv.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (floatingAction (_:)))
        fv.addGestureRecognizer(gesture)
        floatingViewRotation()
    }
    
    private func floatingViewRotation() {
        let animate = presenter.floatingViewRotation()
        floatingView?.imageView?.layer.add(animate, forKey: "rotation")
    }
    
    @objc private func floatingAction(_ sender: UITapGestureRecognizer) {
        let animate = presenter.floatingViewShake()
        sender.view?.layer.add(animate, forKey: "shake")
    }
}

// MARK: - Extensions -

extension ForecastViewController: ForecastViewInterface {
    
    func setupView() {
        navigationController?.navigationBar.isHidden = false
        scrollView.delegate = self
        collectionViewConfigure()
        tableViewConfigure()
    }
    
    func setTitle(with text: String) {
        DispatchQueue.main.async { self.title = text }
    }
    
    // MARK: - Fact Temperature (Header) -
    
    func factTemp(value: String) {
        factTempView.factTemp(with: value)
    }
    
    func factCondition(text: String) {
        factTempView.factCondition(with: text)
    }
    
    func factFeelsLike(text: String) {
        factTempView.factFeelsLike(with: text)
    }
    
    // MARK: - CollectionView: Forecast -
    
    fileprivate func collectionViewConfigure() {
        hourlyForecastView.backgroundColor = .clear
        presenter.collectionViewCreate({ [self] in
            $0.delegate = self
            $0.dataSource = self
            $0.prefetchDataSource = self
            hourlyForecastView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalTo: hourlyForecastView.widthAnchor),
                $0.heightAnchor.constraint(equalTo: hourlyForecastView.heightAnchor)
            ])
            collectionViewHourlyForecast = $0
        })
    }
    
    func tableViewConfigure() {
        guard let tableView = tableView else { return }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ForecastTableViewCell.nib, forCellReuseIdentifier: ForecastTableViewCell.id)
    }
    
    func reloadData() {
        let text = "Обновлено в \(Date().currentTime.dropLast(3))"
        DispatchQueue.main.async { [weak self] in
            self?.updateTimeLabel?.text = text
            self?.collectionViewHourlyForecast?.reloadData()
            self?.tableView?.reloadData()
            print(#function, text)
        }
    }
}

// MARK: - Collection View -

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    internal final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.numberOfSections(in: collectionView)
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return presenter.cellForItemAt(at: indexPath, in: collectionView)
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return presenter.sizeForItemAt(at: indexPath, in: collectionView.bounds)
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return presenter.insetForSection(at: section)
    }
    
    internal final func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}

// MARK: - Table View -

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    internal final func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    internal final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }
    
    internal final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.cellForRow(tableView, at: indexPath)
    }
    
    internal final func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }
    
    internal final func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return floatingView.bounds.height / 2
    }
    
    internal final func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.heightForRowAt(at: indexPath)
    }
    
    internal final func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    internal final func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - Scroll View -

extension ForecastViewController: UIScrollViewDelegate {
    
}
