import Foundation

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

// MARK: - struct MotorcycleOrder

struct MotorcycleOrder {
    static let family = Order(id: .family, title: NSLocalizedString("Families", comment: "Families (of motorcycles)"), comparator: MotorcycleComparator.family)
    
    static let yearAscending = Order(id: .yearAscending,  title: NSLocalizedString("Year ascending", comment: "(order by) Year ascending"),  comparator: MotorcycleComparator.yearAscending)
    static let yearDescending = Order(id: .yearDescending, title: NSLocalizedString("Year descending", comment: "(order by) Year descending"), comparator: MotorcycleComparator.yearDescending)
    
    static let displacementAscending = Order(id: .displacementAscending,  title: NSLocalizedString("Displacement ascending", comment: "(order by) Displacement ascending"),  comparator: MotorcycleComparator.displacementAscending)
    static let displacementDescending = Order(id: .displacementDescending, title: NSLocalizedString("Displacement descending", comment: "(order by) Displacement descending"), comparator: MotorcycleComparator.displacementDescending)
    
    static let boreAscending = Order(id: .boreAscending,  title: NSLocalizedString("Bore ascending", comment: "(order by) Bore ascending"),  comparator: MotorcycleComparator.boreAscending)
    static let boreDescending = Order(id: .boreDescending, title: NSLocalizedString("Bore descending", comment: "(order by) Bore descending"), comparator: MotorcycleComparator.boreDescending)
    
    static let strokeAscending = Order(id: .strokeAscending,  title: NSLocalizedString("Stroke ascending", comment: "(order by) Stroke ascending"),  comparator: MotorcycleComparator.strokeAscending)
    static let strokeDescending = Order(id: .strokeDescending, title: NSLocalizedString("Stroke descending", comment: "(order by) Stroke descending"), comparator: MotorcycleComparator.strokeDescending)
    
    static let powerAscending = Order(id: .powerAscending,  title: NSLocalizedString("Power ascending", comment: "(order by) Power ascending"),  comparator: MotorcycleComparator.powerAscending)
    static let powerDescending = Order(id: .powerDescending, title: NSLocalizedString("Power descending", comment: "(order by) Power descending"), comparator: MotorcycleComparator.powerDescending)
    
    static let wheelbaseAscending = Order(id: .wheelbaseAscending,  title: NSLocalizedString("Wheelbase ascending", comment: "(order by) Wheelbase ascending"),  comparator: MotorcycleComparator.wheelbaseAscending)
    static let wheelbaseDescending = Order(id: .wheelbaseDescending, title: NSLocalizedString("Wheelbase descending", comment: "(order by) Wheelbase descending"), comparator: MotorcycleComparator.wheelbaseDescending)
    
    static let weightAscending = Order(id: .weightAscending,  title: NSLocalizedString("Weight ascending", comment: "(order by) Weight ascending"),  comparator: MotorcycleComparator.weightAscending)
    static let weightDescending = Order(id: .weightDescending, title: NSLocalizedString("Weight descending", comment: "(order by) Weight descending"), comparator: MotorcycleComparator.weightDescending)
}
