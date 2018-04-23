import UIKit

class StrokeCycleFilterTableViewController: UITableViewController {
    
    private var filter: StrokeCycle
    private var selectedStrokeCycle: Motorcycle.Engine.StrokeCycle?
    private var selectedIndexPath: IndexPath?
    private let cases: [(Motorcycle.Engine.StrokeCycle, String)] = [(.twoStroke, "2-stroke"), (.fourStroke, "4-stroke")]
    private let callback: (StrokeCycle) -> ()
    
    init(filter: StrokeCycle, _ callback: @escaping (StrokeCycle) -> ()) {
        self.filter = filter
        self.selectedStrokeCycle = filter.selectedStrokeCycle
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
        filter.selectedStrokeCycle = selectedStrokeCycle
        callback(filter)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        
        cell.textLabel?.text = cases[indexPath.row].1
        
        if selectedStrokeCycle == cases[indexPath.row].0 {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        guard let unwrappedSelected = selectedStrokeCycle else {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
            selectedStrokeCycle = cases[indexPath.row].0
            return
        }
        
        if cases[indexPath.row].0 == unwrappedSelected {
            cell.accessoryType = .none
            selectedIndexPath = indexPath
            selectedStrokeCycle = nil
        } else {
            cell.accessoryType = .checkmark
            if let oldIndexPath = selectedIndexPath, let oldCell = tableView.cellForRow(at: oldIndexPath) {
                oldCell.accessoryType = .none
            }
            selectedIndexPath = indexPath
            selectedStrokeCycle = cases[indexPath.row].0
        }
    }
}
