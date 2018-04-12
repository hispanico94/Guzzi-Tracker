import UIKit

class FamilyFilterViewController: UITableViewController {
    
    private var familyFilter: Family
    private let families: [String]
    private var selectedFamilies: [String] = []
    private let callback: (Family) -> ()
    
    init(filter familyFilter: Family, callback: @escaping (Family) -> ()) {
        self.familyFilter = familyFilter
        self.families = familyFilter.families
        self.selectedFamilies = familyFilter.selectedFamilies
        self.callback = callback
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        familyFilter.selectedFamilies = selectedFamilies
        callback(familyFilter)
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

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
