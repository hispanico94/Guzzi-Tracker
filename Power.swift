import UIKit

struct Power {
    let powers: [Measurement<UnitPower>]
    let smallestPower: Measurement<UnitPower>
    let biggestPower: Measurement<UnitPower>
    var minPower: Measurement<UnitPower> {
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
    var maxPower: Measurement<UnitPower> {
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
    let title = NSLocalizedString("Power", comment: "Power")
    private var caption: String {
        let fromString = NSLocalizedString("from", comment: "lowercase from")
        let toString = NSLocalizedString("to", comment: "lowercase to")
        return fromString + " \(minPower.descriptionWithDecimalsIfPresent) " + toString + " \(maxPower.descriptionWithDecimalsIfPresent)"
    }
    
    init(motorcycleList: [Motorcycle]?) {
        let safeSmallest = Measurement<UnitPower>(value: Double(0), unit: .horsepower)
        let safeBiggest = Measurement<UnitPower>(value: Double(150), unit: .horsepower)
        
        guard let unwrapMotorcycleList = motorcycleList else {
            self.powers = []
            self.smallestPower = safeSmallest
            self.biggestPower = safeBiggest
            self.minPower = self.smallestPower
            self.maxPower = self.biggestPower
            return
        }
        
        self.powers = MotorcycleElements.powers(unwrapMotorcycleList)
        
        self.smallestPower = self.powers.min() ?? safeSmallest
        self.biggestPower = self.powers.max() ?? safeBiggest
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
                        guard let power = motorcycle.engine.power?.peak else {
                            
                            // If the user selected the widest possible range of power or tapped the "Clear" button
                            // in the filter page the motorcycle with power == nil are included in the result
                            if self.minPower == self.smallestPower && self.maxPower == self.biggestPower {
                                return true
                            }
                            
                            return false
                        }
                        return power >= self.minPower && power <= self.maxPower
        })
    }
}
