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
        var text = ""
        
        text = number == 1 ? NSLocalizedString("image", comment: "image (lowercase i)") : NSLocalizedString("images", comment: "images (lowercase i)")
        
        self.textLabel?.text = "\(number) " + text
        return self
    }
}
