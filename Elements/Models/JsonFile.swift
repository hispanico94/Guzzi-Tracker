import Foundation
import Argo
import Curry

// MARK: - JsonFile definition

/// JsonFile represents the parsed top-level JSON of info_moto.json.
/// The top level JSON is composed of:
/// - the `version` key (containing the version number of the file);
/// - the `elements` key (containing the motorcycles informations);
/// - the `texts` key (containing the localized texts that go with the motorcycles)
struct JsonFile {
    let version: Int
    let elements: [Motorcycle]
    let texts: [String: Texts]
}

// MARK: - Extracting the motorcycle list with added texts

extension JsonFile {
    /// Add localized texts to the motorcycles and returns a new array of motorcycles
    /// - returns: an array of motorcycles with localized texts
    func getMotorcycleList() -> [Motorcycle] {
        var motorcycles: [Motorcycle] = []
        motorcycles.reserveCapacity(elements.count)
        
        for element in elements {
            let texts = self.texts[String(element.id)]
            motorcycles.append(element.addTexts(texts))
        }
        
        return motorcycles
    }
}

// MARK: - Conforming to Argo.Decodable protocol

extension JsonFile: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<JsonFile> {
        return Decoded.pure(curry(JsonFile.init))
            .call(json.get(at: Key.JsonFile.version))
            .call(json.get(at: Key.JsonFile.elements))
            .call(json.get(at: Key.JsonFile.texts))
    }
}
