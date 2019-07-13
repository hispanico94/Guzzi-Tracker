import Foundation

// MARK: struct Order

struct Order {
    var id: OrderId
    var title: String
    var comparator: Comparator<Motorcycle>
}

// MARK: Conforming Order to Equatable

extension Order: Equatable {
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
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
