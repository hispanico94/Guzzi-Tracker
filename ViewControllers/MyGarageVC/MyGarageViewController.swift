import UIKit

class MyGarageViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let vcFactory: VCFactory
    
    private weak var motorcycleStorage: Ref<Array<Motorcycle>>?
    
    private var motorcycleList: [Motorcycle]
    private var favoritesMotorcyles: [Motorcycle] = []
    private let favoriteList = FavoritesList.sharedFavoritesList
    
    private let review = Review.sharedReview
    
    // MARK: - Initialization
    
    init(vcFactory: VCFactory) {
        self.vcFactory = vcFactory
        self.motorcycleStorage = vcFactory.motorcycleData.motorcycleStorage
        self.motorcycleList = vcFactory.motorcycleData.motorcycleStorage.value
        
        super.init(style: .plain)
        
        self.motorcycleStorage?.add(listener: "MyGarageViewController") { [weak self] newMotorcycles in
            self?.motorcycleList = newMotorcycles
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        motorcycleStorage?.remove(listener: "MyGarageViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MotorcycleCell", bundle: nil), forCellReuseIdentifier: MotorcycleCell.defaultIdentifier)

        navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - View transition
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavorites()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        review.requestReviewIfPossible()
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
            
            if favoritesMotorcyles.isEmpty {
                setBackgroundView()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        favoritesMotorcyles.swapAt(fromIndexPath.row, to.row)
        favoriteList.swapAt(fromIndexPath.row, to.row)
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
        favoritesMotorcyles.removeAll(keepingCapacity: true)
        
        for id in favoriteList.favorites {
            let motorcycle = motorcycleList.filter { $0.id == id }
            favoritesMotorcyles += motorcycle
        }
        
        setBackgroundView()
        tableView.reloadData()
    }
    
    private func setBackgroundView() {
        if favoritesMotorcyles.isEmpty {
            tableView.backgroundView = TableBackgroundViewController(text: NSLocalizedString("Saved motorcycles will appear here", comment: "Saved motorcycles will appear here")).view
            tableView.tableFooterView = UIView(frame: .zero)
            return
        }
        tableView.backgroundView = nil
        tableView.addFooterView()
    }
    
    @IBAction func didTapInfoButton(sender: UIBarButtonItem) {
        let infoVC = UINavigationController(rootViewController: vcFactory.makeInfoVC())
        present(infoVC, animated: true, completion: nil)
    }
}
