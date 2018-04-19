import UIKit

struct Power {
    let smallestPower: Double   //Measurement<UnitPower>
    let biggestPower: Double    //Measurement<UnitPower>
    var minPower: Double /*Measurement<UnitPower>*/ {
        didSet {
            if (minPower < smallestPower) {
                minPower = smallestPower
            } else if (minPower > biggestPower) {
                minPower = biggestPower
            }
            if (minPower > maxPower) {
                maxPower = minPower
            }
        }
    }
    var maxPower: Double /*Measurement<UnitPower>*/ {
        didSet {
            if (maxPower < smallestPower) {
                maxPower = smallestPower
            } else if (maxPower > biggestPower) {
                maxPower = biggestPower
            }
            if (maxPower < minPower) {
                minPower = maxPower
            }
        }
    }
    private let title = "Power"
    private var caption: String {
        return "from \(minPower) to \(maxPower)"
    }
    
    init(motorcycleList: [Motorcycle]?) {
        let safeSmallest = Double(0)    //Measurement<UnitPower>(value: Double(0), unit: .horsepower)
        let safeBiggest = Double(150)   //Measurement<UnitPower>(value: Double(150), unit: .horsepower)
        
        guard let unwrapMotorcycleList = motorcycleList else {
            self.smallestPower = safeSmallest
            self.biggestPower = safeBiggest
            self.minPower = self.smallestPower
            self.maxPower = self.biggestPower
            return
        }
        
        let powers = MotorcycleElements.powers(unwrapMotorcycleList)
        
        self.smallestPower = powers.min() ?? safeSmallest
        self.biggestPower = powers.max() ?? safeBiggest
        self.minPower = self.smallestPower
        self.maxPower = self.biggestPower
    }
}

extension Power: FilterProvider {
    var filterId: FilterId {
        return .power
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return PowerFilterViewController(filter: self, callback)
    }
    
    func getFilter() -> Filter {
        return Filter(id: self.filterId,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        guard let power = motorcycle.engine.power?.peak else { return false }
                        return power >= self.minPower && power <= self.maxPower
        })
    }
    
    
}
