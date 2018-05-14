//
//  SearchResultsViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 12/05/18.
//  Copyright © 2018 PaoloRocca. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
    private let motorcycleList: [Motorcycle]
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
    
    init(motorcycleList: [Motorcycle]?) {
        self.motorcycleList = motorcycleList ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
