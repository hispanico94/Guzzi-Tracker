import Foundation

enum FilterId: Int {
    case none
    case minMaxYear
    case families
    case weight
    case displacement
    case bore
    case stroke
    case power
}

extension FilterId: Comparable {
    static func <(lhs: FilterId, rhs: FilterId) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}


struct Filter {
    var id: FilterId
    var title: String
    var caption: String
    var predicate: Predicate<Motorcycle>
}

extension Filter: Hashable {
    var hashValue: Int {
        return id.rawValue
    }
    
    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
