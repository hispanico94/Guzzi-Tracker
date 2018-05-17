import UIKit

class MyGarageViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let motorcycleList: [Motorcycle]
    private var favoritesMotorcyles: [Motorcycle] = []
    private let favoriteList = FavoritesList.sharedFavoritesList
    
    // MARK: - Initialization
    
    init(motorcycleList: [Motorcycle]?) {
        if let unwrapMotorcycleList = motorcycleList {
            self.motorcycleList = unwrapMotorcycleList
        } else {
            self.motorcycleList = []
        }
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MotorcycleCell", bundle: nil), forCellReuseIdentifier: MotorcycleCell.defaultIdentifier)

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - View transition
    
    override func viewWillAppear(_ animated: Bool) {
        updateFavorites()
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesMotorcyles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleCell.defaultIdentifier, for: indexPath) as! MotorcycleCell
        return cell.set(withMotorcycleData: favoritesMotorcyles[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedMotorcycleId = favoritesMotorcyles[indexPath.row].id
            favoriteList.remove(deletedMotorcycleId)
            favoritesMotorcyles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        favoritesMotorcyles.swapAt(fromIndexPath.row, to.row)
        favoriteList.swapAt(fromIndexPath.row, to.row)
        print("move rows")
    }
 
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMotorcycle = favoritesMotorcyles[indexPath.row]
        navigationController?.pushViewController(MotorcycleInfoViewController(selectedMotorcycle: selectedMotorcycle,
                                                                              nibName: "MotorcycleInfoViewController",
                                                                              bundle: nil),
                                                 animated: true)
    }

    // MARK: - Private instance methods
    
    private func updateFavorites() {
        self.favoritesMotorcyles.removeAll(keepingCapacity: true)
        
        for id in favoriteList.favorites {
            let motorcycle = self.motorcycleList.filter { $0.id == id }
            self.favoritesMotorcyles += motorcycle
        }
        
        tableView.reloadData()
    }
}