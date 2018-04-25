//
//  MotorcyclesViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 24/02/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit

class MotorcyclesViewController: UITableViewController {
    
    private var motorcycleList: [Motorcycle]
    
    private var motorcycleListToShow: [Motorcycle] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var filters: Array<FilterProvider> {
        didSet {
            let predicate = filters
                .lazy
                .map { $0.getFilter().predicate }
                .reduce({ _ in true }, <>)
            
            motorcycleListToShow = motorcycleList.filter(predicate)
        }
    }
    
    private weak var filterStorage: Ref<Array<FilterProvider>>?
    
    private let vcFactory: VCFactory
    
    init(motorcycleList: [Motorcycle]?, filterStorage: Ref<Array<FilterProvider>>, vcFactory: VCFactory) {
        if let unwrapMotorcycleList = motorcycleList {
            self.motorcycleList = unwrapMotorcycleList
            self.motorcycleListToShow = unwrapMotorcycleList
        } else {
            self.motorcycleList = []
            self.motorcycleListToShow = []
        }
        
        /*
        do {
            motorcycleList = try getMotorcycleListFromJson()
            motorcycleListToShow = motorcycleList
        } catch {
            print("\(error)")
            motorcycleList = []
            motorcycleListToShow = []
        }
        */
        
        filters = filterStorage.value
        self.filterStorage = filterStorage
        self.vcFactory = vcFactory
        
        super.init(nibName: "MotorcyclesViewController", bundle: nil)
        
        filterStorage.add(listener: "MotorcyclesViewController") { [weak self] newFilters in
            self?.filters = newFilters
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        filterStorage?.remove(listener: "MotorcyclesViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MotorcycleCell", bundle: nil), forCellReuseIdentifier: MotorcycleCell.defaultIdentifier)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "filter_icon"),
            style: .plain,
            target: self,
            action: #selector(didTapFilterButton(sender:)))
        
        if motorcycleList.isEmpty {
            presentErrorMessage()
        }
    }
    
    func presentErrorMessage() {
        let alert = UIAlertController(title: "Error", message: "An error occurred while retrieving data. Please try again later.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didTapFilterButton(sender: UIBarButtonItem) {
        navigationController?.pushViewController(vcFactory.makeFiltersVC(), animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motorcycleListToShow.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleCell.defaultIdentifier, for: indexPath) as! MotorcycleCell
        return cell.set(withMotorcycleData: motorcycleListToShow[indexPath.row])
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMotorcycle = motorcycleListToShow[indexPath.row]
        navigationController?.pushViewController(MotorcycleInfoViewController(selectedMotorcycle: selectedMotorcycle,
                                                                              nibName: "MotorcycleInfoViewController",
                                                                              bundle: nil),
                                                                              animated: true)
    }
}
