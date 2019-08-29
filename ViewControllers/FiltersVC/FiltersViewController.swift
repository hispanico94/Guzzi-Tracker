import UIKit

class FiltersViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let filterSection = 0
    private let orderSection = 1
    
    private let filterButton = FilterButton()
    
    // Used for storing the MotorcyleData originalFilters.
    // originalFilters contains the filters made from the motorcycles array extracted from the JSON.
    // This filters are not set by the user and they are used for cleaning all the user selections
    // in the "Filter & Sort" page (handled by this view controller). if the user tap "Clear"
    // this variable is copied in filterProviders restoring the original state of the filters.
    private var originalFilters: [FilterProvider]
    
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
    
    init(motorcycleData: MotorcycleData, motorcyclesDisplayed: Ref<Int>) {
        
        self.originalFilters = motorcycleData.originalFilters
        
        self.filterStorage = motorcycleData.filterStorage
        
        for filter in motorcycleData.filterStorage.value {
            self.filterProviders[filter.filterId] = filter
            self.orderedFilterIds.append(filter.filterId)
        }
        self.orderedFilterIds.sort()
        
        self.oldFilterProviders = self.filterProviders
        
        self.orderStorage = motorcycleData.orderStorage
        self.orders = motorcycleData.orderStorage.value
        self.oldOrders = motorcycleData.orderStorage.value
        
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
        motorcyclesDisplayed?.remove(listener: "FiltersViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40.0
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 40.0
        
        filterButton.addTarget(self, action: #selector(applyAndDismiss), for: UIControl.Event.touchUpInside)
        let toolbarItem = UIBarButtonItem(customView: filterButton.button)
        setToolbarItems([toolbarItem], animated: true)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAndDismiss))
        
        let clearString = NSLocalizedString("Clear", comment: "Clear (filters, criteria, selections)")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: clearString, style: .plain, target: self, action: #selector(clearFiltersAndOrders))
        
        tableView.addFooterView()
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

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView()
        
        switch section {
        case filterSection:
            headerView.text = NSLocalizedString("Filters", comment: "Filters")
        case orderSection:
            headerView.text = NSLocalizedString("Sorting", comment: "Sorting")
        default:
            preconditionFailure("FiltersViewController.tableView(_:viewForHeaderInSection:) - returned an invalid section")
        }
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case filterSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "filterCellIdentifier")
                ?? UITableViewCell(style: .value1, reuseIdentifier: "filterCellIdentifier")
            let filterId = orderedFilterIds[indexPath.row]
            let filter = filterProviders[filterId]?.getFilter()
            
            cell.textLabel?.text = filter?.title
            cell.detailTextLabel?.text = filter?.caption
            
            cell.updateConstraintsIfNeeded()
            
            return cell
        
        case orderSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "sortingCellIdentifier")
                ?? UITableViewCell(style: .default, reuseIdentifier: "sortingCellIdentifier")
            cell.textLabel?.text = orderCellCaption()
            
            cell.accessoryType = .disclosureIndicator
            cell.updateConstraintsIfNeeded()
            
            return cell
            
        default:
            preconditionFailure("FiltersViewController.tableView(_:cellForRowAt:) - returned an invalid indexPath.section")
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch indexPath.section {
        case filterSection:
            let filterId = orderedFilterIds[indexPath.row]
            guard let filterProvider = filterProviders[filterId] else { return }
            navigationController?.pushViewController(filterProvider.getViewController({ [weak self] newFilter in self?.filterProviders[filterId] = newFilter }), animated: true)
            
        case orderSection:
            navigationController?.pushViewController(ComparatorsViewController(orders: orders, { [weak self] newOrders in self?.orders = newOrders }), animated: true)
            
        default:
            return
        }
    }
    
    // MARK: - Private instance methods
    
    @objc private func clearFiltersAndOrders() {
        filterStorage?.value = originalFilters
        for filter in originalFilters {
            filterProviders[filter.filterId] = filter
        }
        
        orders = [MotorcycleOrder.yearDescending]
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
        let formatString = NSLocalizedString("%d criteria selected", comment: "%d criteria selected (&d >= 1, adjust 'criteria' and 'selected' accordingly)")
        return String.localizedStringWithFormat(formatString, orders.count)
    }
}
