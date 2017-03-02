//
//  MotorcycleCell.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 01/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit

class MotorcycleCell: UITableViewCell {
    static let defaultIdentifier: String = "MotorcycleCell"
    
    
    func set(withMotorcycleData motorcycleData: Motorcycle) -> MotorcycleCell{
        textLabel?.text = motorcycleData.name
        
        var detailText = "From " + String(motorcycleData.firstYear)
        if let lastYear = motorcycleData.lastYear {
            detailText += " to " + String(lastYear)
        }
        
        detailTextLabel?.text = detailText
        
        return self
    }
}
