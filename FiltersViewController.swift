//
//  FiltersViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 31/03/18.
//  Copyright © 2018 PaoloRocca. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {
    
    private var filterProviders: [FilterId:FilterProvider] = [:] {
        didSet {
            orderedFilterIds = filterProviders.keys.sorted()
            filterStorage?.value = filterProviders.map { $0.value }
        }
    }
    
    private var orderedFilterIds: [FilterId] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private weak var filterStorage: Ref<Array<FilterProvider>>?
    
    private weak var orderStorage: Ref<Array<Order>>?
    
    init(filterStorage: Ref<Array<FilterProvider>>, orderStorage: Ref<Array<Order>>) {
        self.filterStorage = filterStorage
        
        for filter in filterStorage.value {
            self.filterProviders[filter.filterId] = filter
            self.orderedFilterIds.append(filter.filterId)
        }
        self.orderedFilterIds.sort()
        
        self.orderStorage = orderStorage
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return orderedFilterIds.count
        case 1:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Filters"
        case 1:
            return "List Sorting"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") ?? UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
            cell.textLabel?.text = orderCellCaption()
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "reuseIdentifier")
        let filterId = orderedFilterIds[indexPath.row]
        let filter = filterProviders[filterId]?.getFilter()
        
        cell.textLabel?.text = filter?.title
        cell.detailTextLabel?.text = filter?.caption
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        switch indexPath.section {
        case 0:
            let filterId = orderedFilterIds[indexPath.row]
            guard let filterProvider = filterProviders[filterId] else { return }
            navigationController?.pushViewController(filterProvider.getViewController({ [weak self] newFilter in self?.filterProviders[filterId] = newFilter }), animated: true)
        case 1:
            navigationController?.pushViewController(ComparatorsViewController(orders: orderStorage?.value, { [weak self] newOrders in self?.orderStorage?.value = newOrders }), animated: true)
        default:
            return
        }
    }
    
    
    private func orderCellCaption() -> String? {
        let orderCount = orderStorage?.value.count
        guard let unwrapCount = orderCount else { return nil }
        
        if unwrapCount <= 1 {
            return "\(unwrapCount) sort selected"
        }
        
        return "\(unwrapCount) sorts selected"
    }
    
}
