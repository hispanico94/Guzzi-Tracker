import UIKit

struct Weight {
    let weights: [Measurement<UnitMass>]
    let lightestWeight: Measurement<UnitMass>
    let heaviestWeight: Measurement<UnitMass>
    var minWeight: Measurement<UnitMass> {
        didSet {
            if (minWeight < lightestWeight) {
                minWeight = lightestWeight
            } else if (minWeight > heaviestWeight) {
                minWeight = heaviestWeight
            }
            if (minWeight > maxWeight) {
                maxWeight = minWeight
            }
        }
    }
    var maxWeight: Measurement<UnitMass> {
        didSet {
            if (maxWeight < lightestWeight) {
                maxWeight = lightestWeight
            } else if (maxWeight > heaviestWeight) {
                maxWeight = heaviestWeight
            }
            if (maxWeight < minWeight) {
                minWeight = maxWeight
            }
        }
    }
    let title = NSLocalizedString("Weight", comment: "Weight")
    private var caption: String {
        let fromString = NSLocalizedString("from", comment: "lowercase from")
        let toString = NSLocalizedString("to", comment: "lowercase to")
        return fromString + " \(minWeight.descriptionWithDecimalsIfPresent) " + toString + " \(maxWeight.descriptionWithDecimalsIfPresent)"
    }
    
    init(motorcycleList: [Motorcycle]?) {
        let safeLightest = Measurement<UnitMass>(value: Double(0), unit: .kilograms)
        let safeHeaviest = Measurement<UnitMass>(value: Double(400), unit: .kilograms)
        
        guard let unwrapMotorcycleList = motorcycleList else {
            self.weights = []
            self.lightestWeight = safeLightest
            self.heaviestWeight = safeHeaviest
            self.minWeight = self.lightestWeight
            self.maxWeight = self.heaviestWeight
            return
        }
        
//        self.weights = MotorcycleElements.weights(unwrapMotorcycleList)
        
        let motorcycleWeights = MotorcycleElements.weights(unwrapMotorcycleList)
        
        self.lightestWeight = motorcycleWeights.min() ?? safeLightest
        self.heaviestWeight = motorcycleWeights.max() ?? safeHeaviest
        
        let minValue = (Int(self.lightestWeight.value) / 10) * 10
        let maxValue = ((Int(self.heaviestWeight.value) / 10) + 1) * 10
        
        self.minWeight = Measurement<UnitMass>(value: Double(minValue), unit: .kilograms)
        self.maxWeight = Measurement<UnitMass>(value: Double(maxValue), unit: .kilograms)
        
        self.weights = Array(stride(from: minValue, through: maxValue, by: 10)).map { Measurement<UnitMass>(value: Double($0), unit: .kilograms) }
        
//        self.minWeight = self.lightestWeight
//        self.maxWeight = self.heaviestWeight
    }
}

extension Weight: FilterProvider {
    var filterId: FilterId {
        return .weight
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return WeightFilterViewController(filter: self, callback)
    }
    
    func getFilter() -> Filter {
        return Filter(id: self.filterId,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        let weight = motorcycle.capacitiesAndPerformance.weight
                        return weight >= self.minWeight && weight <= self.maxWeight
        })
    }
    
    
}


