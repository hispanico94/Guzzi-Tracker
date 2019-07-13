import UIKit

class ComparatorsViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let orders: [[Order]] = [
        [MotorcycleOrder.family],
        [MotorcycleOrder.yearAscending, MotorcycleOrder.yearDescending],
        [MotorcycleOrder.displacementAscending, MotorcycleOrder.displacementDescending],
        [MotorcycleOrder.boreAscending, MotorcycleOrder.boreDescending],
        [MotorcycleOrder.strokeAscending, MotorcycleOrder.strokeDescending],
        [MotorcycleOrder.powerAscending, MotorcycleOrder.powerDescending],
        [MotorcycleOrder.wheelbaseAscending, MotorcycleOrder.wheelbaseDescending],
        [MotorcycleOrder.weightAscending, MotorcycleOrder.weightDescending]
    ]
    
    private var selectedOrders: [Order] = []
    private var selectedIndexPaths: [OrderId: IndexPath] = [:]
    private let callback: ([Order]) -> ()
    
    // MARK: - Intialization
    
    init(orders: [Order]?, _ callback: @escaping ([Order]) -> ()) {
        self.selectedOrders = orders ?? [MotorcycleOrder.yearDescending]
        self.callback = callback
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Sorting", comment: "(list) Sorting")
        
        let clearString = NSLocalizedString("Clear", comment: "Clear (filters, criteria, selections)")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: clearString, style: .plain, target: self, action: #selector(clearOrders))
        
        tableView.addFooterView()
    }

    // MARK: - View transition
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if selectedOrders.isEmpty {
            selectedOrders = [orders[1][1]] // assign the default "yearDescending" order to selectedOrders
            callback(selectedOrders)
        } else {
            callback(selectedOrders)
        }
        
        super.viewWillDisappear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders[section].count
    }
    
    // Necessary for making the header separators appear
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") ?? UITableViewCell(style: .value1, reuseIdentifier: "reuseIdentifier")
        
        let currentOrder = orders[indexPath.section][indexPath.row]
        
        cell.detailTextLabel?.textColor = .blue
        cell.detailTextLabel?.text = nil
        cell.textLabel?.text = currentOrder.title
        
        if let index = selectedOrders.firstIndex(of: currentOrder) {
            cell.detailTextLabel?.text = String(index + 1)
            selectedIndexPaths[currentOrder.id] = indexPath
        }

        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView?.backgroundColor = UIColor.lightLegnanoGreen
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let selectedOrder = orders[indexPath.section][indexPath.row]
        
        // Check if selectedOrders already contains the selected order.
        // If so remove the selected order from selectedOrders, updates the cells
        // and indexPath saved in selectedIndexPaths is removed
        if let index = selectedOrders.firstIndex(of: selectedOrder) {
            let removedOrder = selectedOrders.remove(at: index)
            selectedIndexPaths[removedOrder.id] = nil
            cell.detailTextLabel?.text = nil
            updateSelectedCells()
            return
        }
        
        // If the first if scope is not executed it means that selectedOrders does not contains
        // the selected order. Next step is to check if selectedOrders contains another element
        // from the same section (for every section only one selection is possible)
        
        // Check if selectedOrders contains an element from the same section of the selected order.
        // If so swap the old order with the new mantaining the element order, updates the cells and
        // in selectedIndexPaths the indexPath of the old order is removed and the new one is inserted
        if let index = selectedOrders.index(fromFirstMatch: orders[indexPath.section]) {
            let removedOrder = selectedOrders.replaceElement(with: selectedOrder, at: index)
            
            if let oldIndexPath = selectedIndexPaths[removedOrder.id],
                let oldCell = tableView.cellForRow(at: oldIndexPath) {
                oldCell.detailTextLabel?.text = nil
            }
            
            selectedIndexPaths[removedOrder.id] = nil
            selectedIndexPaths[selectedOrder.id] = indexPath
            
            cell.detailTextLabel?.text = String(index + 1)
            
            return
        }
        
        // If also no elements of the same section of the selected order are found in selectedOrders
        // the selected order is appended at the end of selectedOrders, the cell is updated and the
        // indexPath is saved in selectedIndexPaths
        
        selectedOrders.append(selectedOrder)
        selectedIndexPaths[selectedOrder.id] = indexPath
        
        cell.detailTextLabel?.text = String(selectedOrders.count)
    }
    
    // MARK: - Private instance methods
    
    @objc private func clearOrders() {
        selectedOrders.removeAll()
        selectedIndexPaths.removeAll()
        tableView.reloadData()
    }
    
    private func updateSelectedCells() {
        var i = 0
        for order in selectedOrders {
            guard let indexPath = selectedIndexPaths[order.id], let cell = tableView.cellForRow(at: indexPath) else {
                i += 1
                continue
            }
            i += 1
            cell.detailTextLabel?.text = String(i)
        }
    }
}
