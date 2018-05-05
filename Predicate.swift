typealias Predicate<T> = (T) -> Bool

precedencegroup Composition {
    associativity: left
}

infix operator <> : Composition

func <> <T> (lhs: @escaping Predicate<T>, rhs: @escaping Predicate<T>) -> Predicate<T> {
    return { value in
        lhs(value) && rhs(value)
    }
}
