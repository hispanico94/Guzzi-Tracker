import UIKit

extension UITableView {
    func addFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        self.tableFooterView = footerView
        
        let greenFooterView = UIView(frame: .zero)
        greenFooterView.translatesAutoresizingMaskIntoConstraints = false
        greenFooterView.backgroundColor = .lightLegnanoGreen
        footerView.addSubview(greenFooterView)
        
        greenFooterView.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        greenFooterView.leftAnchor.constraint(equalTo: footerView.leftAnchor).isActive = true
        greenFooterView.rightAnchor.constraint(equalTo: footerView.rightAnchor).isActive = true
        greenFooterView.heightAnchor.constraint(equalToConstant: 10000).isActive = true
    }
}

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
