import Argo
import Runes
import Curry

// MARK: - JSON

extension JSON {
    func get <A> (at key: String) -> Decoded<A> where A: Argo.Decodable, A == A.DecodedType {
        return self <| key
    }
    
    func get <A> (at keys: [String]) -> Decoded<A> where A: Argo.Decodable, A == A.DecodedType {
        return self <| keys
    }
}

// MARK: - Decoded

extension Decoded {
    static func pure (_ value: T) -> Decoded<T> {
        return .success(value)
    }
    
    func call <A, B> (_ value: Decoded<A>) -> Decoded<B> where T == (A) -> B {
        return value.apply(self)
    }
    
    static func materialize(_ throwing: () throws -> T) -> Decoded {
        return Argo.materialize(throwing)
    }
    
    func orNil() -> Decoded<T?> {
        switch self {
        case let .success(value):
            return .success(Optional(value))
        case .failure(_):
            return .success(nil)
        }
    }
}


