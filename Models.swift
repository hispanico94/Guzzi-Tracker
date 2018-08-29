import Foundation

// MARK: - Model Structs

struct Motorcycle {
    let id: Int
    let generalInfo: GeneralInfo
    let engine: Engine
    let transmission: Transmission
    let frame: Frame
    let brakes: Brakes
    let capacitiesAndPerformance: CapacitiesAndPerformance
    let notes: String? //optional(text)
    let images: [URL]?
    
    struct GeneralInfo {
        let family: String?
        let name: String
        let firstYear: Int
        let lastYear: Int?
    }
    
    struct Engine {
        let configuration: String? //text
        let strokeCycle: StrokeCycle
        let bore: Measurement<UnitLength>
        let stroke: Measurement<UnitLength>
        let displacement: Displacement
        let compression: Double
        let power: Power?
        let feed: String? //text
        let ignition: String? //text
        
        enum StrokeCycle: Int {
            case twoStroke = 2
            case fourStroke = 4
        }
        
        struct Displacement {
            let real: Measurement<UnitVolume>
            let nominal: Measurement<UnitVolume>
            
            var description: String {
                let realString = NSLocalizedString("Real", comment: "Real Displacement")
                let nominalString = NSLocalizedString("Nominal", comment: "Nominal Displacement")
                return realString + ": \(real.descriptionWithDecimalsIfPresent)\n" + nominalString + ": \(nominal.descriptionWithDecimalsIfPresent)"
            }
        }
        
        struct Power {
            let peak: Measurement<UnitPower>
            let rpm: Int
            
            var description: String {
                let atString = NSLocalizedString("at", comment: "at")
                return "\(peak.descriptionWithDecimalsIfPresent) " + atString + " \(rpm) rpm"
            }
        }
    }
    
    struct Transmission {
        let gearbox: String? //text
        let clutch: String? //text
        let finalDrive: String? //text
    }
    
    struct Frame {
        let type: String? //text
        let frontSuspension: String? //text
        let rearSuspension: String? //text
        let wheelbase: Measurement<UnitLength>
        let wheels: String
        let tyres: String
    }
    
    struct Brakes {
        let type: String? //text
        let frontSize: Measurement<UnitLength>?
        let rearSize: Measurement<UnitLength>?
        let notes: String? //optional(text)
    }
    
    struct CapacitiesAndPerformance {
        let fuelCapacity: Measurement<UnitVolume>?
        let lubricantCapacity: Measurement<UnitVolume>?
        let weight: Measurement<UnitMass>
        let maxSpeed: Measurement<UnitSpeed>?
        let fuelConsumption: Measurement<UnitFuelEfficiency>?
    }
}

extension Motorcycle {
    /// return a new motorcycle with texts added
    /// - parameter texts: struct Texts containing the localized strings, it may be nil
    /// - returns: a new Motorcycle with localized string added if texts is not nil, otherwise returns `self`
    func addTexts(_ texts: Texts?) -> Motorcycle {
        
        guard let texts = texts else { return self }
        
        let capacities = CapacitiesAndPerformance(
            fuelCapacity: self.capacitiesAndPerformance.fuelCapacity,
            lubricantCapacity: self.capacitiesAndPerformance.lubricantCapacity,
            weight: self.capacitiesAndPerformance.weight,
            maxSpeed: self.capacitiesAndPerformance.maxSpeed,
            fuelConsumption: self.capacitiesAndPerformance.fuelConsumption)
        
        let brakes = Brakes(
            type: texts.brakesType,
            frontSize: self.brakes.frontSize,
            rearSize: self.brakes.rearSize,
            notes: texts.brakesNotes)
        
        let frame = Frame(
            type: texts.frameType,
            frontSuspension: texts.frameFrontSuspension,
            rearSuspension: texts.frameRearSuspension,
            wheelbase: self.frame.wheelbase,
            wheels: self.frame.wheels,
            tyres: self.frame.tyres)
        
        let transmission = Transmission(
            gearbox: texts.transmissionGearbox,
            clutch: texts.transmissionClutch,
            finalDrive: texts.transmissionFinalDrive)
        
        let engine = Engine(
            configuration: texts.engineConfiguration,
            strokeCycle: self.engine.strokeCycle,
            bore: self.engine.bore,
            stroke: self.engine.stroke,
            displacement: self.engine.displacement,
            compression: self.engine.compression,
            power: self.engine.power,
            feed: texts.engineFeed,
            ignition: texts.engineIgnition)
        
        return Motorcycle(
            id: self.id,
            generalInfo: self.generalInfo,
            engine: engine,
            transmission: transmission,
            frame: frame,
            brakes: brakes,
            capacitiesAndPerformance: capacities,
            notes: texts.notes,
            images: self.images)
    }
}

struct Texts {
    let engineConfiguration: String
    let engineFeed: String
    let engineIgnition: String
    
    let transmissionGearbox: String
    let transmissionClutch: String
    let transmissionFinalDrive: String
    
    let frameType: String
    let frameFrontSuspension: String
    let frameRearSuspension: String
    
    let brakesType: String
    let brakesNotes: String?
    
    let notes: String?
}

struct JsonFile {
    let version: Int
    let elements: [Motorcycle]
    let texts: [String: Texts]
}

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


