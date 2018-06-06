import UIKit

class FiltersViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let filterSection = 0
    private let orderSection = 1
    
    private let filterButton = FilterButton()
    
    // used for storing the filterProviders array in VCFactory. if the user tap
    // "Clear" this variable is copied in filterProviders restoring the original state prior
    // to the presentation of FiltersViewController.
    private let originalFilterProviders: [FilterProvider]
    
    // used for storing the old active filters. If the user tap "Cancel" this
    // variable is copied in filterProviders and filterStorage.value restoring
    // the default state (no bikes are filtered).
    private var oldFilterProviders: [FilterId:FilterProvider]
    
    // stores the filters with their own filterId as keys. When the user selects
    // or modify a filter the new and modified filter is stored under their filterId
    private var filterProviders: [FilterId:FilterProvider] = [:] {
        didSet {
            orderedFilterIds = filterProviders.keys.sorted()
            filterStorage?.value = filterProviders.map { $0.value }
        }
    }
    
    // because dictionaries (filterProviders) are unordered, the order of the filters
    // is given by this property. The order is important in the tableview. FilterId is
    // an enum with integers as rawValues.
    private var orderedFilterIds: [FilterId] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // used for passing the filters to MotorcyclesViewController.
    // MotorcyclesViewController listen for changes in filterStorage
    private weak var filterStorage: Ref<Array<FilterProvider>>?
    
    // used for storing the old active orders. of the user tap "Cancel" this
    // variable is copied in orders restoring the original state prior
    // to the presentation of FiltersViewController.
    private var oldOrders: [Order]
    
    // used for reloading the data of the tableView (otherwise after selecting
    // the orders the filters page will display the old number of orders selected)
    private var orders: [Order] {
        didSet {
            orderStorage?.value = orders
            tableView.reloadData()
        }
    }
    
    // used for passing the comparators to MotorcyclesViewController.
    // MotorcyclesViewController listen for changes in orderStorage
    private weak var orderStorage: Ref<Array<Order>>?
    
    // used for updating the number of motorcycles displayed in MotorcyclesViewController
    // after the filtering. It stores the result of count on motorcycleListToShow.
    // Self listen for changes in this variable
    private weak var motorcyclesDisplayed: Ref<Int>?
    
    // MARK: - Initialization
    
    init(filterProviders: [FilterProvider], filterStorage: Ref<Array<FilterProvider>>, orderStorage: Ref<Array<Order>>, motorcyclesDisplayed: Ref<Int>) {
        self.originalFilterProviders = filterProviders
        
        self.filterStorage = filterStorage
        
        for filter in filterStorage.value {
            self.filterProviders[filter.filterId] = filter
            self.orderedFilterIds.append(filter.filterId)
        }
        
        self.oldFilterProviders = self.filterProviders
        
        self.orderedFilterIds.sort()
        
        self.orders = orderStorage.value
        self.oldOrders = orderStorage.value
        self.orderStorage = orderStorage
        
        self.motorcyclesDisplayed = motorcyclesDisplayed
        
        super.init(style: .plain)
        
        self.motorcyclesDisplayed?.add(listener: "FiltersViewController") { [weak self] newValue in
            self?.filterButton.setTitle(withValue: newValue)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.motorcyclesDisplayed?.remove(listener: "FiltersViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.addTarget(self, action: #selector(applyAndDismiss), for: UIControlEvents.touchUpInside)
        let toolbarItem = UIBarButtonItem(customView: filterButton.button)
        setToolbarItems([toolbarItem], animated: true)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAndDismiss))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Clear", style: .plain, target: self, action: #selector(clearFiltersAndOrders))
    }
    
    // MARK: - View transition
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
        filterButton.setTitle(withValue: motorcyclesDisplayed?.value)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case filterSection:
            return orderedFilterIds.count
        case orderSection:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case filterSection:
            return "Filters"
        case orderSection:
            return "List Sorting"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == filterSection else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") ?? UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
            cell.textLabel?.text = orderCellCaption()
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "reuseIdentifier")
        let filterId = orderedFilterIds[indexPath.row]
        let filter = filterProviders[filterId]?.getFilter()
        
        cell.textLabel?.text = filter?.title
        cell.detailTextLabel?.text = filter?.caption
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView?.backgroundColor = UIColor.lightLegnanoGreen
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch indexPath.section {
        case 0:
            let filterId = orderedFilterIds[indexPath.row]
            guard let filterProvider = filterProviders[filterId] else { return }
            navigationController?.pushViewController(filterProvider.getViewController({ [weak self] newFilter in self?.filterProviders[filterId] = newFilter }), animated: true)
        case 1:
            navigationController?.pushViewController(ComparatorsViewController(orders: orders, { [weak self] newOrders in self?.orders = newOrders }), animated: true)
        default:
            return
        }
    }
    
    // MARK: - Private instance methods
    
    @objc private func clearFiltersAndOrders() {
        filterStorage?.value = originalFilterProviders
        for filter in originalFilterProviders {
            filterProviders[filter.filterId] = filter
        }
        
        orders = [Order.init(id: .yearDescending, title: "Year descending", comparator: MotorcycleComparator.yearDescending)]
        orderStorage?.value = orders
        
        tableView.reloadData()
    }
    
    @objc private func cancelAndDismiss() {
        filterProviders = oldFilterProviders
        orders = oldOrders
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func applyAndDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    private func orderCellCaption() -> String? {
        let orderCount = orders.count
        
        if orderCount <= 1 {
            return "\(orderCount) sort selected"
        }
        
        return "\(orderCount) sorts selected"
    }
}
