//
//  FiltersViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 31/03/18.
//  Copyright © 2018 PaoloRocca. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {
    
    private var filterProviders: [FilterId:FilterProvider] {
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
    
    init(filterStorage: Ref<Array<FilterProvider>>) {
        filterProviders = [.minMaxYear : MinMaxYear()]
        orderedFilterIds = filterProviders.keys.sorted()
        self.filterStorage = filterStorage
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedFilterIds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "reuseIdentifier")
        let filterId = orderedFilterIds[indexPath.row]
        let filter = filterProviders[filterId]?.getFilter()
        
        cell.textLabel?.text = filter?.title
        cell.detailTextLabel?.text = filter?.caption
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let filterId = orderedFilterIds[indexPath.row]
        guard var filterProvider = filterProviders[filterId] else { return }
        //filterProvider.isActive = filterProvider.isActive == false
        //filterProviders[filterId] = filterProvider
        
        navigationController?.pushViewController(filterProvider.getViewController(), animated: true)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
