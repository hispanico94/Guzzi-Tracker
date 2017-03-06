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
        textLabel?.text = motorcycleData.generalInfo.name
        
        var detailText: String = ""
        if let lastYear = motorcycleData.generalInfo.lastYear {
            detailText = String(motorcycleData.generalInfo.firstYear) + " - " + String(lastYear)
        } else {
            detailText = "From " + String(motorcycleData.generalInfo.firstYear)
        }
        
        detailTextLabel?.text = detailText
        
        return self
    }
}
