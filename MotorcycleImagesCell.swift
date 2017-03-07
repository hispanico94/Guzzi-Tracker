//
//  MotorcycleImagesCell.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 07/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit

class MotorcycleImagesCell: UITableViewCell {
    static let defaultIdentifier = "MotorcycleImagesCell"
    
    static func getCell() -> MotorcycleImagesCell {
        return UINib(nibName: "MotorcycleImagesCell", bundle: nil).instantiate(withOwner: nil, options: nil)
            .first as! MotorcycleImagesCell
    }
    
    func setText(withElementNumber number: Int) -> MotorcycleImagesCell {
        var text = "image"
        if number != 1 {
            text += "s"
        }
        self.textLabel?.text = "\(number) " + text
        return self
    }
}
