import UIKit

class FiltersViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let filterSection = 0
    private let orderSection = 1
    
    private let resultCountLabel = UILabel()
    
    private let originalFilterProviders: [FilterProvider]
    
    private var filterProviders: [FilterId:FilterProvider] = [:] {
        didSet {
            orderedFilterIds = filterProviders.keys.sorted()
            filterStorage?.value = filterProviders.map { $0.value }
        }
    }
    
    private var orderedFilterIds: [FilterId] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private weak var filterStorage: Ref<Array<FilterProvider>>?
    
    // used for reloading the data of the tableView (otherwise after selecting
    // the orders the filters page will display the old number of orders selected)
    private var orders: [Order] {
        didSet {
            orderStorage?.value = orders
            tableView.reloadData()
        }
    }
    
    private weak var orderStorage: Ref<Array<Order>>?
    
    private weak var motorcyclesDisplayed: Ref<Int>?
    
    // MARK: - Initialization
    
    init(filterProviders: [FilterProvider], filterStorage: Ref<Array<FilterProvider>>, orderStorage: Ref<Array<Order>>, motorcyclesDisplayed: Ref<Int>) {
        self.originalFilterProviders = filterProviders
        
        self.filterStorage = filterStorage
        
        for filter in filterStorage.value {
            self.filterProviders[filter.filterId] = filter
            self.orderedFilterIds.append(filter.filterId)
        }
        self.orderedFilterIds.sort()
        
        self.orders = orderStorage.value
        self.orderStorage = orderStorage
        
        self.motorcyclesDisplayed = motorcyclesDisplayed
        
        super.init(style: .plain)
        
        self.motorcyclesDisplayed?.add(listener: "FiltersViewController") { [weak self] newValue in
            self?.setLabelText(withValue: newValue)
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
        
        resultCountLabel.textAlignment = .center
        let toolbarItem = UIBarButtonItem(customView: resultCountLabel)
        setToolbarItems([toolbarItem], animated: true)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Clear", style: .plain, target: self, action: #selector(clearAllSelections))
    }
    
    // MARK: - View transition
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
        setLabelText(withValue: motorcyclesDisplayed?.value)
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
    
    @objc private func clearAllSelections() {
        filterStorage?.value = originalFilterProviders
        for filter in originalFilterProviders {
            filterProviders[filter.filterId] = filter
        }
        
        orders = [Order.init(id: .yearDescending, title: "Year descending", comparator: MotorcycleComparator.yearDescending)]
        orderStorage?.value = orders
        
        tableView.reloadData()
    }
    
    private func setLabelText(withValue value: Int?) {
        guard let unwrapValue = value else { return }
        resultCountLabel.textColor = .black
        
        switch value {
        case 0:
            resultCountLabel.text = "No results"
            resultCountLabel.textColor = .red
        case 1:
            resultCountLabel.text = "\(unwrapValue) result"
        default:
            resultCountLabel.text = "\(unwrapValue) results"
        }
    }
    
    private func orderCellCaption() -> String? {
        let orderCount = orders.count
        
        if orderCount <= 1 {
            return "\(orderCount) sort selected"
        }
        
        return "\(orderCount) sorts selected"
    }
}
