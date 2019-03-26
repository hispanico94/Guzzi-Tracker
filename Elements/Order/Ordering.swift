import Foundation

// MARK: enum Ordering

enum Ordering {
    case lt
    case eq
    case gt
}

// MARK: Conforming Ordering to Monoid

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

// MARK: Conforming OrderId to Comparable

extension OrderId: Comparable {
    static func < (lhs: OrderId, rhs: OrderId) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
