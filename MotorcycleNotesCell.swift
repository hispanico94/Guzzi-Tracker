//
//  MotorcycleNotesCell.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 07/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit

class MotorcycleNotesCell: UITableViewCell {
    static let defaultIdentifier = "MotorcycleNotesCell"
    
    @IBOutlet weak var label: UILabel!
    
    static func getCell() -> MotorcycleNotesCell {
        return UINib(nibName: "MotorcycleNotesCell", bundle: nil).instantiate(withOwner: nil, options: nil)
                                                                 .first as! MotorcycleNotesCell
    }
    
    func set(withRowNote rowNote: RowNote) -> MotorcycleNotesCell {
        label.text = rowNote.note
        return self
    }
}
