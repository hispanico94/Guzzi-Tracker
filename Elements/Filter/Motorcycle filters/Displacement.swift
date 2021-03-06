import UIKit

struct Displacement {
    let displacements: [Measurement<UnitVolume>]
    let smallestDisplacement: Measurement<UnitVolume>
    let biggestDisplacement: Measurement<UnitVolume>
    var minDisplacement: Measurement<UnitVolume> {
        didSet {
            if (minDisplacement < smallestDisplacement) {
                minDisplacement = smallestDisplacement
            } else if (minDisplacement > biggestDisplacement) {
                minDisplacement = biggestDisplacement
            }
            if (minDisplacement > maxDisplacement) {
                maxDisplacement = minDisplacement
            }
        }
    }
    var maxDisplacement: Measurement<UnitVolume> {
        didSet {
            if (maxDisplacement < smallestDisplacement) {
                maxDisplacement = smallestDisplacement
            } else if (maxDisplacement > biggestDisplacement) {
                maxDisplacement = biggestDisplacement
            }
            if (maxDisplacement < minDisplacement) {
                minDisplacement = maxDisplacement
            }
        }
    }
    let title = NSLocalizedString("Displacement", comment: "Displacement")
    private var caption: String {
        let fromString = NSLocalizedString("from", comment: "lowercase from")
        let toString = NSLocalizedString("to", comment: "lowercase to")
        return fromString + " \(minDisplacement.customLocalizedDescription) " + toString + " \(maxDisplacement.customLocalizedDescription)"
    }
    
    init(motorcycleList: [Motorcycle]?) {
        let safeSmallest = Measurement<UnitVolume>(value: Double(0), unit: .engineCubicCentimeters)
        let safeBiggest = Measurement<UnitVolume>(value: Double(2000), unit: .engineCubicCentimeters)
        
        guard let unwrapMotorcycleList = motorcycleList else {
            self.displacements = []
            self.smallestDisplacement = safeSmallest
            self.biggestDisplacement = safeBiggest
            self.minDisplacement = self.smallestDisplacement
            self.maxDisplacement = self.biggestDisplacement
            return
        }
        
        self.displacements = MotorcycleElements.displacements(unwrapMotorcycleList)
        
        self.smallestDisplacement = self.displacements.min() ?? safeSmallest
        self.biggestDisplacement = self.displacements.max() ?? safeBiggest
        self.minDisplacement = self.smallestDisplacement
        self.maxDisplacement = self.biggestDisplacement
    }
}

extension Displacement: FilterProvider {
    var filterId: FilterId {
        return .displacement
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return DisplacementFilterViewController(filter: self, callback)
    }
    
    func getFilter() -> Filter {
        return Filter(id: self.filterId,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        let displacement = motorcycle.engine.displacement.nominal
                        return displacement >= self.minDisplacement && displacement <= self.maxDisplacement
        })
    }
}



