import UIKit

struct Weight {
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
    private let title = "Weight"
    private var caption: String {
        return "From \(minWeight) To \(maxWeight)"
    }
    
    init(motorcycleList: [Motorcycle]?) {
        let safeLightest = Measurement<UnitMass>(value: Double(0), unit: .kilograms)
        let safeHeaviest = Measurement<UnitMass>(value: Double(500), unit: .kilograms)
        
        guard let unwrapMotorcycleList = motorcycleList else {
            self.lightestWeight = safeLightest
            self.heaviestWeight = safeHeaviest
            self.minWeight = self.lightestWeight
            self.maxWeight = self.heaviestWeight
            return
        }
        
        let weights = MotorcycleElements.weights(unwrapMotorcycleList)
        
        self.lightestWeight = weights.min() ?? safeLightest
        self.heaviestWeight = weights.max() ?? safeHeaviest
        self.minWeight = self.lightestWeight
        self.maxWeight = self.heaviestWeight
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


