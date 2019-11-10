import Foundation

// MARK: - Motorcycle definition

/// Motorcycle represents the motorcycle data (but not the texts) under the `elements` key in the info_moto.json JSON file.
/// In particular, the correct representation of the data under `elements` is `[Motorcycle]` where every instance of Motorcycle
/// represent a motorcycle with its data.
struct Motorcycle: Identifiable {
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
                return realString + ": \(real.customLocalizedDescription)\n" + nominalString + ": \(nominal.customLocalizedDescription)"
            }
        }
        
        struct Power {
            let peak: Measurement<UnitPower>
            let rpm: Int
            
            var description: String {
                let atString = NSLocalizedString("at", comment: "at")
                return "\(peak.customLocalizedDescription) " + atString + " \(rpm) rpm"
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

// MARK: - Getting the specs string for RowElement and MotorcycleInfoCell

extension Motorcycle.GeneralInfo {
    var getFamilyString: String { return family ?? "---" }
    var getNameString: String { return name }
    var getFirstYearString: String { return firstYear.description }
    var getLastYearString: String { return lastYear?.description ?? "..." }
}

extension Motorcycle.Engine {
    var getConfigurationString: String { return configuration ?? "---" }
    var getCompressionString: String { return compression.customLocalizedDescription + " : 1" }
    var getPowerString: String { return power?.description ?? "---" }
    var getFeedString: String { return feed ?? "---" }
    var getIgnitionString: String { return ignition ?? "---" }
    var getBoreString: String { return bore.customLocalizedDescription }
    var getStrokeString: String { return stroke.customLocalizedDescription }
    var getDisplacementString: String { return displacement.description }
}

extension Motorcycle.Transmission {
    var getGearboxString: String { return gearbox ?? "---" }
    var getClutchString: String { return clutch ?? "---" }
    var getFinalDriveString: String { return finalDrive ?? "---" }
}

extension Motorcycle.Frame {
    var getTypeString: String { return type ?? "---" }
    var getFrontSuspensionString: String { return frontSuspension ?? "---" }
    var getRearSuspensionString: String { return rearSuspension ?? "---" }
    var getWheelbaseString: String { return wheelbase.customLocalizedDescription }
    var getWheelsString: String { return wheels }
    var getTyresString: String { return tyres }
}

extension Motorcycle.Brakes {
    var getTypeString: String { return type ?? "---" }
    var getFrontSizeString: String { return frontSize?.customLocalizedDescription ?? "---" }
    var getRearSizeString: String { return rearSize?.customLocalizedDescription ?? "---" }
    var getNotesString: String { return notes ?? "---" }
}

extension Motorcycle.CapacitiesAndPerformance {
    var getFuelCapacityString: String { return fuelCapacity?.customLocalizedDescription ?? "---" }
    var getLubricantCapacityString: String { return lubricantCapacity?.customLocalizedDescription ?? "---" }
    var getWeightString: String { return weight.customLocalizedDescription }
    var getMaxSpeedString: String { return maxSpeed?.customLocalizedDescription ?? "---" }
    var getFuelConsumptionString: String { return fuelConsumption?.customLocalizedDescription ?? "---" }
}

// MARK: - Conforming to ArrayConvertible protocol

extension Motorcycle.GeneralInfo: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.append(RowElement(rowKey: Key.Motorcycle.GeneralInfo.family.guiKey,
                                   rowValue: getFamilyString))
        elements.append(RowElement(rowKey: Key.Motorcycle.GeneralInfo.name.guiKey,
                                   rowValue: getNameString))
        elements.append(RowElement(rowKey: Key.Motorcycle.GeneralInfo.firstYear.guiKey,
                                   rowValue: getFirstYearString))
        elements.append(RowElement(rowKey: Key.Motorcycle.GeneralInfo.lastYear.guiKey,
                                   rowValue: getLastYearString))
        return elements
    }
}

extension Motorcycle.Engine: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.reserveCapacity(8)
        
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.configuration.guiKey,
                                   rowValue: getConfigurationString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.bore.guiKey,
                                   rowValue: getBoreString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.stroke.guiKey,
                                   rowValue: getStrokeString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.Displacement.guiKey,
                                   rowValue: getDisplacementString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.compression.guiKey,
                                   rowValue: getCompressionString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.Power.guiKey,
                                   rowValue: getPowerString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.feed.guiKey,
                                   rowValue: getFeedString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.ignition.guiKey,
                                   rowValue: getIgnitionString))
        return elements
    }
}

extension Motorcycle.Transmission: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.reserveCapacity(3)
        
        elements.append(RowElement(rowKey: Key.Motorcycle.Transmission.gearbox.guiKey,
                                   rowValue: getGearboxString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Transmission.clutch.guiKey,
                                   rowValue: getClutchString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Transmission.finalDrive.guiKey,
                                   rowValue: getFinalDriveString))
        return elements
    }
}

extension Motorcycle.Frame: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.reserveCapacity(6)
        
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.type.guiKey,
                                   rowValue: getTypeString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.frontSuspension.guiKey,
                                   rowValue: getFrontSuspensionString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.rearSuspension.guiKey,
                                   rowValue: getRearSuspensionString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.wheelbase.guiKey,
                                   rowValue: getWheelbaseString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.wheels.guiKey,
                                   rowValue: getWheelsString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.tyres.guiKey,
                                   rowValue: getTyresString))
        return elements
    }
}

extension Motorcycle.Brakes: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.reserveCapacity(3)
        
        elements.append(RowElement(rowKey: Key.Motorcycle.Brakes.type.guiKey,
                                   rowValue: getTypeString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Brakes.frontSize.guiKey,
                                   rowValue: getFrontSizeString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Brakes.rearSize.guiKey,
                                   rowValue: getRearSizeString))
        
        if notes != nil {
            elements.append(RowElement(rowKey: Key.Motorcycle.Brakes.notes.guiKey,
                                       rowValue: getNotesString))
        }
        
        return elements
    }
}

extension Motorcycle.CapacitiesAndPerformance: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.reserveCapacity(5)
        
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.fuelCapacity.guiKey,
                                   rowValue: getFuelCapacityString))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.lubricantCapacity.guiKey,
                                   rowValue: getLubricantCapacityString))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.weight.guiKey,
                                   rowValue: getWeightString))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.maxSpeed.guiKey,
                                   rowValue: getMaxSpeedString))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.fuelConsumption.guiKey,
                                   rowValue: getFuelConsumptionString))
        return elements
    }
}

// MARK: - Section Data array from Motorcycle

extension Motorcycle {
    /// Returns an array of SectionData containing the informations of `self`.
    /// This method is used for populating the tableView of MotorcycleInfoViewController.
    /// - returns: an array of SectionData
    func makeArray() -> [SectionData] {
        var elements: [SectionData] = []
        elements.reserveCapacity(6)
        
        elements.append(SectionData(sectionName: Key.Motorcycle.GeneralInfo.guiKey,
                                    sectionElements: generalInfo.convertToArray()))
        elements.append(SectionData(sectionName: Key.Motorcycle.Engine.guiKey,
                                    sectionElements: engine.convertToArray()))
        elements.append(SectionData(sectionName: Key.Motorcycle.Transmission.guiKey,
                                    sectionElements: transmission.convertToArray()))
        elements.append(SectionData(sectionName: Key.Motorcycle.Frame.guiKey,
                                    sectionElements: frame.convertToArray()))
        elements.append(SectionData(sectionName: Key.Motorcycle.Brakes.guiKey,
                                    sectionElements: brakes.convertToArray()))
        elements.append(SectionData(sectionName: Key.Motorcycle.CapacitiesAndPerformance.guiKey,
                                    sectionElements: capacitiesAndPerformance.convertToArray()))
        
        if let unwrapNotes = self.notes {
            elements.append(SectionData(sectionName: Key.Motorcycle.notes.guiKey,
                                        sectionElements: [RowNote(note: unwrapNotes)]))
        }
        if let unwrapImages = self.images {
            elements.append(SectionData(sectionName: Key.Motorcycle.images.guiKey,
                                        sectionElements: [RowImage(urls: unwrapImages)]))
        }
        
        return elements
    }
}

// MARK: - Conforming Motorcycle.Engine.StrokeCycle to Comparable protocol

extension Motorcycle.Engine.StrokeCycle: Comparable {
    static func <(lhs: Motorcycle.Engine.StrokeCycle, rhs: Motorcycle.Engine.StrokeCycle) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    static func <=(lhs: Motorcycle.Engine.StrokeCycle, rhs: Motorcycle.Engine.StrokeCycle) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    static func >(lhs: Motorcycle.Engine.StrokeCycle, rhs: Motorcycle.Engine.StrokeCycle) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    
    static func >=(lhs: Motorcycle.Engine.StrokeCycle, rhs: Motorcycle.Engine.StrokeCycle) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
}
