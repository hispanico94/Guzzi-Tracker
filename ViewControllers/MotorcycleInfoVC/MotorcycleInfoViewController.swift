//
//  MotorcycleInfoViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 06/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit

class MotorcycleInfoViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let motorcycle: Motorcycle
    private let motorcycleArray: [SectionData]
    
    private let favoriteList = FavoritesList.sharedFavoritesList
    
    private let favoriteIcon = UIImage(named: "favorite_icon")
    private let selectedFavoriteIcon = UIImage(named: "selected_favorite_icon")
    
    // MARK: - Initialization
    
    init(selectedMotorcycle motorcycle: Motorcycle, nibName: String?, bundle: Bundle?) {
        self.motorcycle = motorcycle
        motorcycleArray = motorcycle.makeArray()
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.0
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 100.0
        
        navigationItem.title = motorcycle.generalInfo.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: "Back"), style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(didTapFavoriteButton))
    }
    
    // MARK: - View transition
    
    override func viewWillAppear(_ animated: Bool) {
        toggleIcon(on: favoriteList.contains(motorcycle.id))
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return motorcycleArray.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView()
        headerView.text = motorcycleArray[section].sectionName
        return headerView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return motorcycleArray[section].sectionElements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return motorcycleArray[indexPath.section].sectionElements[indexPath.row].makeTableViewCell(forTableView: tableView)
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = motorcycleArray[indexPath.section].sectionElements[indexPath.row]
        handle(cellSelection: selectedCell.selectionBehavior, nextViewControllerTitle: motorcycle.generalInfo.name)
    }
    
    // MARK: - Private instance methods
    
    @objc private func didTapFavoriteButton() {
        if favoriteList.contains(motorcycle.id) {
            favoriteList.remove(motorcycle.id)
            toggleIcon(on: false)
        } else {
            favoriteList.add(motorcycle.id)
            toggleIcon(on: true)
        }
        
    }
    
    private func toggleIcon(on: Bool) {
        if on {
            navigationItem.rightBarButtonItem?.image = selectedFavoriteIcon
        } else {
            navigationItem.rightBarButtonItem?.image = favoriteIcon
        }
    }
    
}
