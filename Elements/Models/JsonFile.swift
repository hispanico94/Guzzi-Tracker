import Foundation

// MARK: - JsonFile definition

/// JsonFile represents the parsed top-level JSON of info_moto.json.
/// The top level JSON is composed of:
/// - the `version` key (containing the version number of the file);
/// - the `elements` key (containing the motorcycles informations);
/// - the `texts` key (containing the localized texts that go with the motorcycles)
struct JsonFile: Decodable {
    let version: Int
    let elements: [MotorcycleJson]
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
            motorcycles.append(element.getMotorcycle(with: texts))
        }
        
        return motorcycles
    }
}
