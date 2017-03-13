//
//  ImagesViewController.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 09/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit
import AlamofireImage

class ImagesViewController: UITableViewController {
    private let imageAspectRatio = CGFloat(1.77778)
    private let pinnedDistanceImageViewInCell = CGFloat(4)
    
    private let imageUrls: [URL]
    private let motorcycleName: String
    private var imageUrlRequests: [URLRequest] {
        var imageUrlRequests: [URLRequest] = []
        for url in imageUrls {
            imageUrlRequests.append(URLRequest(url: url))
        }
        return imageUrlRequests
    }
    
    init(motorcycleName name: String, imagesUrls urls: RowImage, nibName: String?, bundle: Bundle?) {
        motorcycleName = name
        imageUrls = urls.urls
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        ImageDownloader().download(imageUrlRequests)
        
        navigationItem.title = motorcycleName
        
        tableView.rowHeight = calculateRowHeight(withWidth: UIScreen.main.bounds.width)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.rowHeight = calculateRowHeight(withWidth: size.width)
    }

    private func calculateRowHeight(withWidth width: CGFloat) -> CGFloat {
        return (width / imageAspectRatio) + pinnedDistanceImageViewInCell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return imageUrls[indexPath.row].makeTableViewCell(forTableView: tableView)
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
