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
    var filterId: FilterId { get }
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController
    func getFilter() -> Filter
}
