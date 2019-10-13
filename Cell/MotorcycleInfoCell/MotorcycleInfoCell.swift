//
//  MotorcycleInfoCell.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 06/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit

class MotorcycleInfoCell: UITableViewCell {
    static let defaultIdentifier = "MotorcycleInfoCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static func getCell() -> MotorcycleInfoCell {
        return UINib(nibName: "MotorcycleInfoCell", bundle: nil).instantiate(withOwner: nil, options: nil)
                                                                .first as! MotorcycleInfoCell
    }
    
    func set(withRowElement rowElement: RowElement) -> MotorcycleInfoCell {
        titleLabel.text = rowElement.rowKey + ":"
        descriptionLabel.text = rowElement.rowValue
        return self
    }

    
}
