import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var motorcycleStorage: Ref<Array<Motorcycle>>?
    
    private var motorcycleList: [Motorcycle]
    
    private let searchController: UISearchController
    
    private let searchResultsViewController: SearchResultsViewController
    
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: - Initialization
    
    init(motorcycleStorage: Ref<Array<Motorcycle>>) {
        self.motorcycleStorage = motorcycleStorage
        
        self.motorcycleList = motorcycleStorage.value
        
        self.searchResultsViewController = SearchResultsViewController(motorcycleStorage: motorcycleStorage)
        self.searchController = UISearchController(searchResultsController: self.searchResultsViewController)
        self.searchController.searchResultsUpdater = searchResultsViewController
        
        super.init(nibName: nil, bundle: nil)
        
        self.motorcycleStorage?.add(listener: "SearchViewController") { [weak self] newMotorcycles in
            self?.motorcycleList = newMotorcycles
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        motorcycleStorage?.remove(listener: "SearchViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsViewController.callback = { [weak self] selectedMotorcycle in
            self?.navigationController?.pushViewController(MotorcycleInfoViewController(selectedMotorcycle: selectedMotorcycle,
                                                                                        nibName: "MotorcycleInfoViewController",
                                                                                        bundle: nil),
                                                           animated: true)
        }
        
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        view.backgroundColor = UIColor.lightLegnanoGreen
        
        detailLabel.text = NSLocalizedString("To start searching, tap the bar on top", comment: "To start searching, tap the bar on top")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchController.searchBar.setPlaceholderText(NSLocalizedString("Search Motorcycles", comment: "Search Motorcycles"), withColor: .gray)
        self.searchController.searchBar.setIconColor(.gray)
    }
}
