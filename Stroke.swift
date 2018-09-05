import UIKit

struct Stroke {
    let strokes: [Measurement<UnitLength>]
    let smallestStroke: Measurement<UnitLength>
    let biggestStroke: Measurement<UnitLength>
    var minStroke: Measurement<UnitLength> {
        didSet {
            if (minStroke < smallestStroke) {
                minStroke = smallestStroke
            } else if (minStroke > biggestStroke) {
                minStroke = biggestStroke
            }
            if (minStroke > maxStroke) {
                maxStroke = minStroke
            }
        }
    }
    var maxStroke: Measurement<UnitLength> {
        didSet {
            if (maxStroke < smallestStroke) {
                maxStroke = smallestStroke
            } else if (maxStroke > biggestStroke) {
                maxStroke = biggestStroke
            }
            if (maxStroke < minStroke) {
                minStroke = maxStroke
            }
        }
    }
    let title = NSLocalizedString("Stroke", comment: "Stroke")
    private var caption: String {
        let fromString = NSLocalizedString("from", comment: "lowercase from")
        let toString = NSLocalizedString("to", comment: "lowercase to")
        return fromString + " \(minStroke.customLocalizedDescription) " + toString + " \(maxStroke.customLocalizedDescription)"
    }
    
    init(motorcycleList: [Motorcycle]?) {
        let safeSmallest = Measurement<UnitLength>(value: Double(0), unit: .millimeters)
        let safeBiggest = Measurement<UnitLength>(value: Double(150), unit: .millimeters)
        
        guard let unwrapMotorcycleList = motorcycleList else {
            self.strokes = []
            self.smallestStroke = safeSmallest
            self.biggestStroke = safeBiggest
            self.minStroke = self.smallestStroke
            self.maxStroke = self.biggestStroke
            return
        }
        
        self.strokes = MotorcycleElements.strokes(unwrapMotorcycleList)
        
        self.smallestStroke = self.strokes.min() ?? safeSmallest
        self.biggestStroke = self.strokes.max() ?? safeBiggest
        self.minStroke = self.smallestStroke
        self.maxStroke = self.biggestStroke
    }
}

extension Stroke: FilterProvider {
    var filterId: FilterId {
        return .stroke
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return StrokeFilterViewController(filter: self, callback)
    }
    
    func getFilter() -> Filter {
        return Filter(id: self.filterId,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        let stroke = motorcycle.engine.stroke
                        return stroke >= self.minStroke && stroke <= self.maxStroke
        })
    }
}
