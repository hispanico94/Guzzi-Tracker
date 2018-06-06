import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    private let motorcycleList: [Motorcycle]
    
    private let searchController: UISearchController
    
    private let searchResultsViewController: SearchResultsViewController
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: - Initialization
    
    init(motorcycleList: [Motorcycle]?) {
        self.motorcycleList = motorcycleList ?? []
        
        self.searchResultsViewController = SearchResultsViewController(motorcycleList: motorcycleList)
        self.searchController = UISearchController(searchResultsController: self.searchResultsViewController)
        self.searchController.searchResultsUpdater = searchResultsViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        headerLabel.textColor = UIColor.gray
        headerLabel.textColor = UIColor.gray
        
        headerLabel.text = "Search Motorcycles"
        detailLabel.text = "Tap the search bar above to search motorcycles"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchController.searchBar.setPlaceholderText("Search Motorcycles", withColor: .gray)
        self.searchController.searchBar.setIconColor(.gray)
    }
}
