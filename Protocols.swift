//
//  Protocols.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 05/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit

protocol CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell
}

protocol ArrayConvertible {
    func convertToArray() -> [CellRepresentable]
}

protocol FilterProvider {
    var isActive: Bool { get set }
    // var filterId: FilterId { get }
    func getFilter() -> Filter
    func getViewController() -> UIViewController
}
