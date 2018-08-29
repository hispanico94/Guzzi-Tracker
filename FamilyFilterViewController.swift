import UIKit

class FamilyFilterViewController: UITableViewController {
    
    private var filter: Family
    private let families: [String]
    private var selectedFamilies: [String] = []
    private let callback: (Family) -> ()
    
    init(filter: Family, callback: @escaping (Family) -> ()) {
        self.filter = filter
        self.families = filter.families
        self.selectedFamilies = filter.selectedFamilies
        self.callback = callback
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = filter.title
        
        let clearString = NSLocalizedString("Clear", comment: "Clear (filters, criteria, selections)")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: clearString, style: .plain, target: self, action: #selector(clearSelection))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        filter.selectedFamilies = selectedFamilies
        callback(filter)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") ?? UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")

        cell.textLabel?.text = families[indexPath.row]
        cell.accessoryType = .none
        
        if selectedFamilies.contains(families[indexPath.row]) {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if let i = selectedFamilies.index(of: families[indexPath.row]) {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
                selectedFamilies.remove(at: i)
            }
        } else {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                selectedFamilies.append(families[indexPath.row])
            }
        }
    }
    
    @objc private func clearSelection() {
        selectedFamilies.removeAll()
        tableView.reloadData()
    }
}
