import UIKit

struct Wheelbase {
    let wheelbases: [Measurement<UnitLength>]
    let smallestWheelbase: Measurement<UnitLength>
    let biggestWheelbase: Measurement<UnitLength>
    var minWheelbase: Measurement<UnitLength> {
        didSet {
            if (minWheelbase < smallestWheelbase) {
                minWheelbase = smallestWheelbase
            } else if (minWheelbase > biggestWheelbase) {
                minWheelbase = biggestWheelbase
            }
            if (minWheelbase > maxWheelbase) {
                maxWheelbase = minWheelbase
            }
        }
    }
    var maxWheelbase: Measurement<UnitLength> {
        didSet {
            if (maxWheelbase < smallestWheelbase) {
                maxWheelbase = smallestWheelbase
            } else if (maxWheelbase > biggestWheelbase) {
                maxWheelbase = biggestWheelbase
            }
            if (maxWheelbase < minWheelbase) {
                minWheelbase = maxWheelbase
            }
        }
    }
    let title = NSLocalizedString("Wheelbase", comment: "Wheelbase")
    private var caption: String {
        let fromString = NSLocalizedString("from", comment: "lowercase from")
        let toString = NSLocalizedString("to", comment: "lowercase to")
        return fromString + " \(minWheelbase.descriptionWithDecimalsIfPresent) " + toString + " \(maxWheelbase.descriptionWithDecimalsIfPresent)"
    }
    
    init(motorcycleList: [Motorcycle]?) {
        let safeSmallest = Measurement<UnitLength>(value: Double(500), unit: .millimeters)
        let safeBiggest = Measurement<UnitLength>(value: Double(2000), unit: .millimeters)
        
        guard let unwrapMotorcycleList = motorcycleList else {
            self.wheelbases = []
            self.smallestWheelbase = safeSmallest
            self.biggestWheelbase = safeBiggest
            self.minWheelbase = self.smallestWheelbase
            self.maxWheelbase = self.biggestWheelbase
            return
        }
        
        self.wheelbases = MotorcycleElements.wheelbases(unwrapMotorcycleList)
        
        self.smallestWheelbase = self.wheelbases.min() ?? safeSmallest
        self.biggestWheelbase = self.wheelbases.max() ?? safeBiggest
        self.minWheelbase = self.smallestWheelbase
        self.maxWheelbase = self.biggestWheelbase
    }
}

extension Wheelbase: FilterProvider {
    var filterId: FilterId {
        return .wheelbase
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return WheelbaseFilterViewController(filter: self, callback)
    }
    
    func getFilter() -> Filter {
        return Filter(id: self.filterId,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        let wheelbase = motorcycle.frame.wheelbase
                        return wheelbase >= self.minWheelbase && wheelbase <= self.maxWheelbase
        })
    }
}
