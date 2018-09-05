//MARK: - protocol Monoid

protocol Monoid {
    static func <> (lhs: Self, rhs: Self) -> Self
    static var empty: Self { get }
}

// MARK: - struct Function

struct Function<Input, Output> {
    let call: (Input) -> Output
}

// MARK: - Conforming Function to Monoid

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
