struct Function<Input, Output> {
    let call: (Input) -> Output
}

extension Function: Monoid where Output: Monoid{
    static func <>(lhs: Function, rhs: Function) -> Function {
        return Function { x in
            return lhs.call(x) <> rhs.call(x)
        }
    }
    
    static var empty: Function {
        return Function { _ in Output.empty }
    }
}

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
