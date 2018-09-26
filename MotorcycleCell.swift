import UIKit

class MotorcycleCell: UITableViewCell {
    static let defaultIdentifier: String = "MotorcycleCell"
    
    
    func set(withMotorcycleData motorcycleData: Motorcycle) -> MotorcycleCell{
        textLabel?.text = motorcycleData.generalInfo.name
        
        var detailText: String = ""
        if let lastYear = motorcycleData.generalInfo.lastYear {
            detailText = String(motorcycleData.generalInfo.firstYear) + " - " + String(lastYear)
        } else {
            let fromString = NSLocalizedString("From", comment: "From (year)")
            detailText = fromString + " " + String(motorcycleData.generalInfo.firstYear)
        }
        
        detailTextLabel?.text = detailText
        
        return self
    }
}
