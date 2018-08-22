// MARK: - enum Ordering

enum Ordering {
    case lt
    case eq
    case gt
}

extension Ordering: Monoid {
    static func <>(lhs: Ordering, rhs: Ordering) -> Ordering {
        switch (lhs, rhs) {
        case (.lt, _):
            return .lt
        case (.gt, _):
            return .gt
        case (.eq, _):
            return rhs
        }
    }
    
    static let empty = Ordering.eq
}

// MARK: - enum OrderId

enum OrderId: Int {
    case none
    case name
    case family
    case yearAscending
    case yearDescending
    case displacementAscending
    case displacementDescending
    case boreAscending
    case boreDescending
    case strokeAscending
    case strokeDescending
    case powerAscending
    case powerDescending
    case wheelbaseAscending
    case wheelbaseDescending
    case weightAscending
    case weightDescending
}

extension OrderId: Comparable {
    static func < (lhs: OrderId, rhs: OrderId) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// MARK: - typealias Comparator

typealias Comparator<A> = Function<(A, A), Ordering>

// MARK: - struct Order

struct Order {
    var id: OrderId
    var title: String
    var comparator: Comparator<Motorcycle>
}

extension Order: Hashable {
    var hashValue: Int {
        return id.rawValue
    }
    
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

// MARK: - Comparators:

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
