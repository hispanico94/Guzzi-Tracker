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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        if selectedFamilies.contains(families[indexPath.row]) {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
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
}
