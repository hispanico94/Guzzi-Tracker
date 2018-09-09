import UIKit

class InfoViewController: UITableViewController {
    
    let informations = Information.defaultInformations.makeArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(44)
        tableView.addFooterView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return informations.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informations[section].sectionElements.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return informations[section].sectionName
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return informations[indexPath.section].sectionElements[indexPath.row].makeTableViewCell(forTableView: tableView)
    }
 
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView?.backgroundColor = .lightLegnanoGreen
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let selectedCell = informations[indexPath.section].sectionElements[indexPath.row]
        handle(cellSelection: selectedCell.selectionBehavior)
    }
    
    // MARK: - IBActions

    @IBAction func didTapDoneButton(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
