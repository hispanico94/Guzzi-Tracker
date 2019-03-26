import UIKit

class SearchResultsViewController: UITableViewController {
    
    // MARK: - Properties
    
    private weak var motorcycleStorage: Ref<Array<Motorcycle>>?
    
    private var motorcycleList: [Motorcycle]
    private var filteredMotorcycleList: [Motorcycle] = []
    
    // callback gets assigned in SearchViewController's viewDidLoad()
    var callback: ((Motorcycle) -> ())?
    
    private var searchText: String? {
        didSet {
            guard let unwrapped = searchText else { return }
            
            filteredMotorcycleList = motorcycleList.filter { motorcycle in
                motorcycle.generalInfo.name.lowercased().contains(unwrapped.lowercased())
            }
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Initialization
    
    init(motorcycleStorage: Ref<Array<Motorcycle>>) {
        self.motorcycleStorage = motorcycleStorage
        self.motorcycleList = motorcycleStorage.value
        
        super.init(nibName: nil, bundle: nil)
        
        self.motorcycleStorage?.add(listener: "SearchResultsViewController") { [weak self] newMotorcycles in
            self?.motorcycleList = newMotorcycles
            self?.searchText = self?.searchText
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        motorcycleStorage?.remove(listener: "SearchResultsViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MotorcycleCell", bundle: nil), forCellReuseIdentifier: MotorcycleCell.defaultIdentifier)
        
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMotorcycleList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleCell.defaultIdentifier, for: indexPath) as! MotorcycleCell
        return cell.set(withMotorcycleData: filteredMotorcycleList[indexPath.row])
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let selectedMotorcycle = filteredMotorcycleList[indexPath.row]
        callback?(selectedMotorcycle)
    }
    
}

// MARK: - UISearchResultsUpdating delegate

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text
    }
}
