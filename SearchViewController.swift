//
//  SearchViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 12/05/18.
//  Copyright © 2018 PaoloRocca. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let motorcycleList: [Motorcycle]
    
    private let searchController: UISearchController
    
    private let searchResultsViewController: SearchResultsViewController
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    
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
        searchController.searchBar.placeholder = "Search Motorcycles"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        
        
        headerLabel.text = "Search Motorcycles"
        detailLabel.text = "Tap the search bar above to search motorcycles"
    }
}
