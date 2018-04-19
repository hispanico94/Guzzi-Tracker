import UIKit

struct Bore {
    let smallestBore: Measurement<UnitLength>
    let biggestBore: Measurement<UnitLength>
    var minBore: Measurement<UnitLength> {
        didSet {
            if (minBore < smallestBore) {
                minBore = smallestBore
            } else if (minBore > biggestBore) {
                minBore = biggestBore
            }
            if (minBore > maxBore) {
                maxBore = minBore
            }
        }
    }
    var maxBore: Measurement<UnitLength> {
        didSet {
            if (maxBore < smallestBore) {
                maxBore = smallestBore
            } else if (maxBore > biggestBore) {
                maxBore = biggestBore
            }
            if (maxBore < minBore) {
                minBore = maxBore
            }
        }
    }
    private let title = "Bore"
    private var caption: String {
        return "from \(minBore) to \(maxBore)"
    }
    
    init(motorcycleList: [Motorcycle]?) {
        let safeSmallest = Measurement<UnitLength>(value: Double(0), unit: .millimeters)
        let safeBiggest = Measurement<UnitLength>(value: Double(150), unit: .millimeters)
        
        guard let unwrapMotorcycleList = motorcycleList else {
            self.smallestBore = safeSmallest
            self.biggestBore = safeBiggest
            self.minBore = self.smallestBore
            self.maxBore = self.biggestBore
            return
        }
        
        let bores = MotorcycleElements.bores(unwrapMotorcycleList)
        
        self.smallestBore = bores.min() ?? safeSmallest
        self.biggestBore = bores.max() ?? safeBiggest
        self.minBore = self.smallestBore
        self.maxBore = self.biggestBore
    }
}

extension Bore: FilterProvider {
    var filterId: FilterId {
        return .bore
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return BoreFilterViewController(filter: self, callback)
    }
    
    func getFilter() -> Filter {
        return Filter(id: self.filterId,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        let bore = motorcycle.engine.bore
                        return bore >= self.minBore && bore <= self.maxBore
        })
    }
}
