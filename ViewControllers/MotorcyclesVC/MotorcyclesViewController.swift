import UIKit

class MotorcyclesViewController: UITableViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Properties
    
    private var motorcycleList: [Motorcycle] {
        didSet {
            motorcycleListToShow = motorcycleList
            sortMotorcycleList()
        }
    }
    
    private let motorcyclesDisplayed: Ref<Int>
    
    private var motorcycleListToShow: [Motorcycle] {
        didSet(oldArray) {
            motorcyclesDisplayed.value = motorcycleListToShow.count
            
            if splitViewController?.isCollapsed == false {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
                splitViewController?.showDetailViewController(EmptyViewController(), sender: nil)
            }
            
            if #available(iOS 13.0, *) {
                performDiffs(oldArray: oldArray)
            } else {
                tableView.reloadData()
            }
        }
    }
    
    private var filters: Array<FilterProvider> {
        didSet {
            filterPredicate = filters
                .lazy
                .map { $0.getFilter().predicate }
                .reduce({ _ in true }, <>)
        }
    }
    
    private var filterPredicate: Predicate<Motorcycle> = { _ in true } {
        didSet {
            getNewMotorcycleListToShow()
        }
    }
    
    private var orders: Array<Order> {
        didSet {
            let comparators = orders
                .lazy
                .map { $0.comparator }
                .reduce(Comparator.empty, <>)
            
            // used as a final sort rule
            let internalComparator = MotorcycleComparator.name
            
            comparator = (comparators <> internalComparator)
        }
    }
    
    private var comparator: Function<(Motorcycle, Motorcycle), Ordering> = MotorcycleComparator.yearDescending <> MotorcycleComparator.name {
        didSet {
            getNewMotorcycleListToShow()
        }
    }
    
    private weak var motorcycleStorage: Ref<Array<Motorcycle>>?
    
    private weak var filterStorage: Ref<Array<FilterProvider>>?
    
    private weak var orderStorage: Ref<Array<Order>>?
    
    private let vcFactory: VCFactory

    private let review = Review.sharedReview
    
    private var searchTextPredicate: Predicate<Motorcycle> = { _ in true } {
        didSet {
            getNewMotorcycleListToShow()
        }
    }
    
    private var searchText: String? {
        didSet {
            if let searchText = searchText, searchText.isEmpty == false {
                searchTextPredicate = { $0.generalInfo.name.lowercased().contains(searchText.lowercased()) }
            } else {
                searchTextPredicate = { _ in true }
            }
        }
    }
    
    // MARK: - Initialization
    
    init(vcFactory: VCFactory) {
        self.vcFactory = vcFactory
        
        self.motorcycleStorage = vcFactory.motorcycleData.motorcycleStorage
        self.filterStorage = vcFactory.motorcycleData.filterStorage
        self.orderStorage = vcFactory.motorcycleData.orderStorage
        
        self.motorcycleList = vcFactory.motorcycleData.motorcycleStorage.value
        self.filters = vcFactory.motorcycleData.filterStorage.value
        self.orders = vcFactory.motorcycleData.orderStorage.value
        
        self.motorcycleListToShow = self.motorcycleList.sorted(by: comparator)
        
        self.motorcyclesDisplayed = Ref<Int>.init(self.motorcycleList.count)
        
        super.init(nibName: nil, bundle: nil)
        
        self.filterStorage?.add(listener: "MotorcyclesViewController") { [weak self] newFilters in
            self?.filters = newFilters
        }
        
        self.orderStorage?.add(listener: "MotorcyclesViewController") { [weak self] newOrders in
            self?.orders = newOrders
        }
        
        self.motorcycleStorage?.add(listener: "MotorcyclesViewController") { [weak self] newMotorcycles in
            self?.motorcycleList = newMotorcycles
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        filterStorage?.remove(listener: "MotorcyclesViewController")
        orderStorage?.remove(listener: "MotorcyclesViewController")
        motorcycleStorage?.remove(listener: "MotorcyclesViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MotorcycleCell", bundle: nil), forCellReuseIdentifier: MotorcycleCell.defaultIdentifier)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: "Back"), style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "filter_icon"),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton(sender:))
        )
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        if #available(iOS 13, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            definesPresentationContext = true
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        if motorcycleList.isEmpty {
            presentErrorMessage()
        }
    }
    
    // MARK: - View transition
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 13, *) {} else {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
        
        review.requestReviewIfPossible()
    }
    
    // MARK: - Interface Builder methods
    
    @IBAction func didTapFilterButton(sender: UIBarButtonItem) {
        let navigationVC = UINavigationController(rootViewController: vcFactory.makeFiltersVC(motorcyclesDisplayed: motorcyclesDisplayed))
        
        if #available(iOS 13.0, *) {
            navigationVC.isModalInPresentation = true
        }
        
        present(navigationVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motorcycleListToShow.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleCell.defaultIdentifier, for: indexPath) as! MotorcycleCell
        return cell.set(withMotorcycleData: motorcycleListToShow[indexPath.row])
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMotorcycle = motorcycleListToShow[indexPath.row]
        splitViewController?.showDetailViewController(
            MotorcycleInfoViewController(
                selectedMotorcycle: selectedMotorcycle,
                nibName: "MotorcycleInfoViewController",
                bundle: nil
            ),
            sender: nil
        )
    }
    
    // MARK: - Private instance methods
    
    private func presentErrorMessage() {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "list extraction error"), message: NSLocalizedString("(DATA EXTRACTION ERROR)", comment: "Error during data extraction"), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func sortMotorcycleList() {
        let comparators = orders
            .lazy
            .map { $0.comparator }
            .reduce(Comparator.empty, <>)
        
        // used as a final sort rule
        let internalComparator = MotorcycleComparator.name
        
        motorcycleListToShow.sort(by: comparators <> internalComparator)
    }
    
    private func getNewMotorcycleListToShow() {
        motorcycleListToShow = motorcycleList
        .lazy
        .filter(filterPredicate <> searchTextPredicate)
        .sorted(by: comparator)
    }
    
    @available(iOS 13, *)
    private func performDiffs(oldArray: [Motorcycle]) {
        let diffs = motorcycleListToShow.difference(from: oldArray) { $0.id == $1.id }
        
        tableView.performBatchUpdates({
            for change in diffs {
                switch change {
                case .remove(let offset, _, _):
                    tableView.deleteRows(at: [IndexPath(row: offset, section: 0)], with: .automatic)
                case .insert(let offset, _, _):
                    tableView.insertRows(at: [IndexPath(row: offset, section: 0)], with: .automatic)
                }
            }
        }, completion: { [weak self] animationCompleted in
            guard
                animationCompleted,
                let self = self,
                self.tableView.numberOfRows(inSection: 0) > 0,
                self.tableView.indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)) == false
                else { return }
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            
        })
    }
}

extension MotorcyclesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text
    }
}
