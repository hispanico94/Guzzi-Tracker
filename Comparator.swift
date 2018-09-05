typealias Comparator<A> = Function<(A, A), Ordering>

// MARK: Comparator implementations

// Extending Comparable to implement Comparator
extension Comparable {
    static func comparator(ascending: Bool = true) -> Comparator<Self> {
        return Comparator.init { lhs, rhs in
            if ascending { return lhs < rhs ? .lt : lhs > rhs ? .gt : .eq }
            return lhs < rhs ? .gt : lhs > rhs ? .lt : .eq
        }
    }
}

// Extending Optional to implement Comparator
// Necessary for optional properties
// nil elements are moved at the end of the list
extension Optional where Wrapped: Comparable {
    
    /// Returns a comparator where nil elements are moved at the end of the list
    static func comparator(ascending: Bool = true) -> Comparator<Optional> {
        return Comparator.init { lhs, rhs in
            switch (lhs, rhs) {
            case (.none, _):
                return .gt
            case (_, .none):
                return .lt
            case (let left?, let right?):
                if ascending { return left < right ? .lt : left > right ? .gt : .eq }
                return left < right ? .gt : left > right ? .lt : .eq
            }
        }
    }
}

// MARK: Extending Function to return Comparator

// Comparator<A> is defined as Function<(A, A), Ordering>
extension Function {
    
    /// Returns a comparator without having to specify the same non-optional property for both the compared elements
    static func getOn<Compared, Property>(ascending: Bool = true, _ getProperty: @escaping (Compared) -> Property) -> Comparator<Compared> where Property: Comparable, Input == (Compared, Compared), Output == Ordering {
        return Comparator<Compared> { tuple in
            let (firstCompared, secondCompared) = tuple
            return Property.comparator(ascending: ascending).call((getProperty(firstCompared), getProperty(secondCompared)))
        }
    }
    
    /// Returns a comparator without having to specify the same optional property for both the compared elements
    static func getOn<Compared, Property>(ascending: Bool = true, _ getProperty: @escaping (Compared) -> Optional<Property>) -> Comparator<Compared> where Property: Comparable, Input == (Compared, Compared), Output == Ordering {
        return Comparator<Compared> { tuple in
            let (firstCompared, secondCompared) = tuple
            return Optional<Property>.comparator(ascending: ascending).call((getProperty(firstCompared), getProperty(secondCompared)))
        }
    }
}

// MARK: - struct MotorcycleComparator

struct MotorcycleComparator {
    /// Returns a comparator for motorcycle names. It's used internally as a final sort, it's not selectable by the user
    static let name = Comparator<Motorcycle>.getOn { $0.generalInfo.name }
    
    static let family = Comparator<Motorcycle>.getOn { $0.generalInfo.family }
    
    static let yearAscending = Comparator<Motorcycle>.getOn { $0.generalInfo.firstYear }
    static let yearDescending = Comparator<Motorcycle>.getOn(ascending: false) { $0.generalInfo.firstYear }
    
    static let displacementAscending = Comparator<Motorcycle>.getOn { $0.engine.displacement.real }
    static let displacementDescending = Comparator<Motorcycle>.getOn(ascending: false) { $0.engine.displacement.real }
    
    static let boreAscending = Comparator<Motorcycle>.getOn { $0.engine.bore }
    static let boreDescending = Comparator<Motorcycle>.getOn(ascending: false) { $0.engine.bore }
    
    static let strokeAscending = Comparator<Motorcycle>.getOn { $0.engine.stroke }
    static let strokeDescending = Comparator<Motorcycle>.getOn(ascending: false) { $0.engine.stroke }
    
    static let powerAscending = Comparator<Motorcycle>.getOn { $0.engine.power?.peak }
    static let powerDescending = Comparator<Motorcycle>.getOn(ascending: false) { $0.engine.power?.peak }
    
    static let wheelbaseAscending = Comparator<Motorcycle>.getOn { $0.frame.wheelbase }
    static let wheelbaseDescending = Comparator<Motorcycle>.getOn(ascending: false) { $0.frame.wheelbase }
    
    static let weightAscending = Comparator<Motorcycle>.getOn { $0.capacitiesAndPerformance.weight }
    static let weightDescending = Comparator<Motorcycle>.getOn(ascending: false) { $0.capacitiesAndPerformance.weight }
}
