import UIKit

class MotorcyclesViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var motorcycleList: [Motorcycle] {
        didSet {
            motorcycleListToShow = motorcycleList
            sortMotorcycleList()
        }
    }
    
    private let motorcyclesDisplayed: Ref<Int>
    
    private var motorcycleListToShow: [Motorcycle] {
        didSet {
            motorcyclesDisplayed.value = motorcycleListToShow.count
            
            if splitViewController?.isCollapsed == false {
                splitViewController?.showDetailViewController(EmptyViewController(), sender: nil)
            }
            
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    private var filters: Array<FilterProvider> {
        didSet {
            let predicate = filters
                .lazy
                .map { $0.getFilter().predicate }
                .reduce({ _ in true }, <>)
            
            motorcycleListToShow = motorcycleList.filter(predicate)
            sortMotorcycleList()
        }
    }
    
    private var orders: Array<Order> {
        didSet {
            sortMotorcycleList()
        }
    }
    
    private weak var motorcycleStorage: Ref<Array<Motorcycle>>?
    
    private weak var filterStorage: Ref<Array<FilterProvider>>?
    
    private weak var orderStorage: Ref<Array<Order>>?
    
    private let vcFactory: VCFactory

    private let review = Review.sharedReview
    
    // MARK: - Initialization
    
    init(vcFactory: VCFactory) {
        self.vcFactory = vcFactory
        
        self.motorcycleStorage = vcFactory.motorcycleData.motorcycleStorage
        self.filterStorage = vcFactory.motorcycleData.filterStorage
        self.orderStorage = vcFactory.motorcycleData.orderStorage
        
        self.motorcycleList = vcFactory.motorcycleData.motorcycleStorage.value
        self.filters = vcFactory.motorcycleData.filterStorage.value
        
        self.motorcycleListToShow = self.motorcycleList
        
        self.motorcyclesDisplayed = Ref<Int>.init(self.motorcycleList.count)
        
        // self.orders is initialized empty and in viewDidLoad() gets the
        // value from orderStorage in order to call its didSet observer
        self.orders = []
        
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
        
        // the orders' didSet observer is called
        orders = orderStorage?.value ?? []
        
        tableView.register(UINib(nibName: "MotorcycleCell", bundle: nil), forCellReuseIdentifier: MotorcycleCell.defaultIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50.0
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: "Back"), style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "filter_icon"),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton(sender:))
        )
        
        tableView.addFooterView()
        
        if motorcycleList.isEmpty {
            presentErrorMessage()
        }
    }
    
    // MARK: - View transition
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        review.requestReviewIfPossible()
    }
    
    // MARK: - Interface Builder methods
    
    @IBAction func didTapFilterButton(sender: UIBarButtonItem) {
        let navigationVC = UINavigationController(rootViewController: vcFactory.makeFiltersVC(motorcyclesDisplayed: motorcyclesDisplayed))
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
}
