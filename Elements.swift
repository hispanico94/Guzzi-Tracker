struct MotorcycleElements {
    static let families = elementsFromMotorcycles { $0.generalInfo.family }
    static let firstYears = elementsFromMotorcycles { $0.generalInfo.firstYear }
    static let strokeCycles = elementsFromMotorcycles { $0.engine.strokeCycle }
    static let bores = elementsFromMotorcycles { $0.engine.bore }
    static let strokes = elementsFromMotorcycles { $0.engine.stroke }
    static let displacements = elementsFromMotorcycles { $0.engine.displacement }
    static let compressions = elementsFromMotorcycles { $0.engine.compression }
    static let powers = elementsFromMotorcycles { $0.engine.power?.peak }
    static let wheelbases = elementsFromMotorcycles { $0.frame.wheelbase }
    static let fuelCapacities = elementsFromMotorcycles { $0.capacitiesAndPerformance.fuelCapacity }
    static let weights = elementsFromMotorcycles { $0.capacitiesAndPerformance.weight }
}

func elementsFromMotorcycles <T: Comparable> (_ binding: @escaping (Motorcycle) -> T?) -> ([Motorcycle]) -> [T] {
    return { motorcycleArray in
        motorcycleArray
            .map(binding)
            .filter {$0 != nil}
            .map { $0! }
            .removeDuplicates()
    }
}

