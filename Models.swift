import Foundation

// MARK: - Model Structs

struct Motorcycle {
    let id: Int
    let generalInfo: GeneralInfo
    let engine: Engine
    let frame: Frame
    let capacitiesAndPerformance: CapacitiesAndPerformance
    let notes: String?
    let images: [URL]?
    
    struct GeneralInfo {
        let family: String?
        let name: String
        let firstYear: Int
        let lastYear: Int?
    }
    
    struct Engine {
        let configuration: String
        let strokeCycle: StrokeCycle
        let bore: Measurement<UnitLength>
        let stroke: Measurement<UnitLength>
        let displacement: Measurement<UnitVolume>
        let compression: Double
        let power: Power?
        let feedSystem: String
        
        enum StrokeCycle: Int {
            case twoStroke = 2
            case fourStroke = 4
        }
        
        struct Power {
            let peak: Measurement<UnitPower>
            let rpm: Int
            var formattedValue: String {
                return "\(peak.descriptionWithDecimalsIfPresent) at \(rpm) rpm"
            }
        }
    }
    
    struct Frame {
        let type: String
        let frontSuspension: String
        let rearSuspension: String
        let wheelbase: Measurement<UnitLength>
        let brakes: String
    }
    
    struct CapacitiesAndPerformance {
        let fuelCapacity: Measurement<UnitVolume>?
        let lubricantCapacity: Measurement<UnitVolume>?
        let weight: Measurement<UnitMass>
        let maxSpeed: Measurement<UnitSpeed>?
        let fuelConsumption: Measurement<UnitFuelEfficiency>?
    }
}

struct JsonFile {
    let version: Int
    let elements: [Motorcycle]
}

// MARK: - View Model Structs

struct SectionData {
    let sectionName: String
    let sectionElements: [CellRepresentable]
}

struct RowElement {
    let rowKey: String
    let rowValue: String
}

struct RowNote {
    let note: String
}

struct RowImage {
    let urls: [URL]
}


