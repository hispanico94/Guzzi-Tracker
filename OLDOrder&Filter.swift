//
//  Order&Filter.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 21/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import Foundation

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

enum MotorcycleOrdering: Equatable {
    case none
    case byName(ascending: Bool)
    case byFamily(ascending: Bool)
    case byFirstYear(ascending: Bool)
    case byLastYear(ascending: Bool)
    case byBore(ascending: Bool)
    case byStroke(ascending: Bool)
    case byDisplacement(ascending: Bool)
    case byCompression(ascending: Bool)
    case byPower(ascending: Bool)
    case byWheelbase(ascending: Bool)
    case byFuelCapacity(ascending: Bool)
    case byWeight(ascending: Bool)
    case byMaxSpeed(ascending: Bool)
    case byFuelConsumption(ascending: Bool)
    
    var title: String {
        switch self {
        case .none:
            return "none"
        case .byName(let ascending):
            return ascending ? "Name Ascending" : "Name Descending"
        case .byFamily(let ascending):
            return ascending ? "Family Ascending" : "Family Descending"
        case .byFirstYear(let ascending):
            return ascending ? "Introducion year ascending" : "Introduction year descending"
        case .byLastYear(let ascending):
            return ascending ? "Discontinued year ascending" : "Discontinued year descending"
        case .byBore(let ascending):
            return ascending ? "Bore size ascending" : "Bore size descending"
        case .byStroke(let ascending):
            return ascending ? "Stroke size ascending" : "Stroke size descending"
        case .byDisplacement(let ascending):
            return ascending ? "Displacement ascending" : "Displacement descending"
        case .byCompression(let ascending):
            return ascending ? "Compression ratio ascending" : "Compression ratio descending"
        case .byPower(let ascending):
            return ascending ? "Horsepower ascending" : "Horsepower descending"
        case .byWheelbase(let ascending):
            return ascending ? "Wheelbase ascending" : "Wheelbase descending"
        case .byFuelCapacity(let ascending):
            return ascending ? "Fuel capacity ascending" : "Fuel capacity descending"
        case .byWeight(let ascending):
            return ascending ? "Weight ascending" : "Weight descending"
        case .byMaxSpeed(let ascending):
            return ascending ? "Maximum speed ascending" : "Maximum speed descending"
        case .byFuelConsumption(let ascending):
            return ascending ? "Fuel consumption ascending" : "Fuel consumption descending"
        }
    }
    
    var comparator: MotorcycleComparator {
        switch self {
        case .none:
            return { _, _ in return true }
        case .byName(let ascending):
            return {motorcycleComparatorFunction(ascending: ascending, firstElement: $0.generalInfo.name, secondElement: $1.generalInfo.name)}
        case .byFamily(let ascending):
            return {motorcycleComparatorFunction(ascending: ascending, firstElement: $0.generalInfo.family, secondElement: $1.generalInfo.family)}
        default:
            return { _, _ in return true }
        }
    }
}

func == (lhs: MotorcycleOrdering, rhs: MotorcycleOrdering) -> Bool {
    switch (lhs, rhs) {
    case (.none, .none):
        return true
    case (.byName(let lhsAscending), .byName(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byFamily(let lhsAscending), .byFamily(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byFirstYear(let lhsAscending), .byFirstYear(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byLastYear(let lhsAscending), .byLastYear(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byBore(let lhsAscending), .byBore(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byStroke(let lhsAscending), .byStroke(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byDisplacement(let lhsAscending), .byDisplacement(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byCompression(let lhsAscending), .byCompression(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byPower(let lhsAscending), .byPower(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byWheelbase(let lhsAscending), .byWheelbase(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byFuelCapacity(let lhsAscending), .byFuelCapacity(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byWeight(let lhsAscending), .byWeight(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byMaxSpeed(let lhsAscending), .byMaxSpeed(let rhsAscending)):
        return lhsAscending == rhsAscending
    case (.byFuelConsumption(let lhsAscending), .byFuelConsumption(let rhsAscending)):
        return lhsAscending == rhsAscending
    default:
        return false
    }
}

//Se firstElement è nil ritorna false, se secondElement è nil ritorna true (non escludo gli elementi nil, ma gli sposto alla fine della lista)
//confronto con <
//se ascending è true ritorno il risultato del confronto, se è false inverto il risultato del ritorno
func motorcycleComparatorFunction<T: Comparable>(ascending: Bool, firstElement: T?, secondElement: T?) -> Bool {
    guard let unwrapFirst = firstElement else {return false}
    guard let unwrapSecond = secondElement else {return true}
    return ascending ? unwrapFirst < unwrapSecond : unwrapFirst > unwrapSecond
}






