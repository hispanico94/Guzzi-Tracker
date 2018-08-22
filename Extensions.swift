import UIKit
import Argo
import Runes
import Curry

extension Decoded {
    static func pure (_ value: T) -> Decoded<T> {
        return .success(value)
    }
    
    func call <A, B> (_ value: Decoded<A>) -> Decoded<B> where T == (A) -> B {
        return value.apply(self)
    }
}

extension JSON {
    func get <A> (at key: String) -> Decoded<A> where A: Argo.Decodable, A == A.DecodedType {
        return self <| key
    }
    
    func get <A> (at keys: [String]) -> Decoded<A> where A: Argo.Decodable, A == A.DecodedType {
        return self <| keys
    }
}

// MARK: - Conforming to Decodable protocol

extension Motorcycle: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle> {
        
        let id: Decoded<Int> = json.get(at: Key.Motorcycle.id.jsonKey)
        let generalInfo: Decoded<Motorcycle.GeneralInfo> = json.get(at: Key.Motorcycle.GeneralInfo.jsonKey)
        let engine: Decoded<Motorcycle.Engine> = json.get(at: Key.Motorcycle.Engine.jsonKey)
        let transmission: Decoded<Motorcycle.Transmission> = json.get(at: Key.Motorcycle.Transmission.jsonKey)
        let frame: Decoded<Motorcycle.Frame> = json.get(at: Key.Motorcycle.Frame.jsonKey)
        let brakes: Decoded<Motorcycle.Brakes> = json.get(at: Key.Motorcycle.Brakes.jsonKey)
        let capacities: Decoded<Motorcycle.CapacitiesAndPerformance> = json.get(at: Key.Motorcycle.CapacitiesAndPerformance.jsonKey)
        let images: Decoded<[URL]?> = json.get(at: Key.Motorcycle.images.jsonKey).orNil()
        
        return Decoded.pure(curry(Motorcycle.init))
            .call(id)
            .call(generalInfo)
            .call(engine)
            .call(transmission)
            .call(frame)
            .call(brakes)
            .call(capacities)
            .call(Decoded.pure(nil)) //notes
            .call(images)
    }
}

extension Motorcycle.GeneralInfo: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.GeneralInfo> {
        
        let family: Decoded<String?> = json.get(at: Key.Motorcycle.GeneralInfo.family.jsonKey).orNil()
        let name: Decoded<String> = json.get(at: Key.Motorcycle.GeneralInfo.name.jsonKey)
        let firstYear: Decoded<Int> = json.get(at: Key.Motorcycle.GeneralInfo.firstYear.jsonKey)
        let lastYear: Decoded<Int?> = json.get(at: Key.Motorcycle.GeneralInfo.lastYear.jsonKey).orNil()
        
        return Decoded.pure(curry(Motorcycle.GeneralInfo.init))
            .call(family)
            .call(name)
            .call(firstYear)
            .call(lastYear)
    }
}

extension Motorcycle.Engine: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Engine> {
        
        let strokeCycle: Decoded<StrokeCycle> = json.get(at: Key.Motorcycle.Engine.strokeCycle.jsonKey)
        
        let bore: Decoded<Measurement<UnitLength>> = json
            .get(at: Key.Motorcycle.Engine.bore.jsonKey)
            .map { Measurement<UnitLength>(value: $0, unit: .millimeters) }
        
        let stroke: Decoded<Measurement<UnitLength>> = json
            .get(at: Key.Motorcycle.Engine.stroke.jsonKey)
            .map { Measurement<UnitLength>(value: $0, unit: .millimeters) }
        
        let displacement: Decoded<Displacement> = json.get(at: Key.Motorcycle.Engine.Displacement.jsonKey)
        let compression: Decoded<Double> = json.get(at: Key.Motorcycle.Engine.compression.jsonKey)
        let power: Decoded<Power?> = json.get(at: Key.Motorcycle.Engine.Power.jsonKey).orNil()
        
        return Decoded.pure(curry(Motorcycle.Engine.init))
            .call(Decoded.pure(nil)) //configuration
            .call(strokeCycle)
            .call(bore)
            .call(stroke)
            .call(displacement)
            .call(compression)
            .call(power)
            .call(Decoded.pure(nil)) //feed
            .call(Decoded.pure(nil)) //ignition
    }
}

extension Motorcycle.Engine.Displacement: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Engine.Displacement> {
        
        let realDisplacement: Decoded<Measurement<UnitVolume>> = json
            .get(at: Key.Motorcycle.Engine.Displacement.real.jsonKey)
            .map { Measurement<UnitVolume>(value: $0, unit: .engineCubicCentimeters) }
        
        let nominalDisplacement: Decoded<Measurement<UnitVolume>> = json
            .get(at: Key.Motorcycle.Engine.Displacement.nominal.jsonKey)
            .map { Measurement<UnitVolume>(value: $0, unit: .engineCubicCentimeters) }
        
        return Decoded.pure(curry(Motorcycle.Engine.Displacement.init))
            .call(realDisplacement)
            .call(nominalDisplacement)
    }
}

extension Motorcycle.Engine.StrokeCycle: Argo.Decodable { }

extension Motorcycle.Engine.Power: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Engine.Power> {
        
        let power: Decoded<Measurement<UnitPower>> = json
            .get(at: Key.Motorcycle.Engine.Power.peak.jsonKey)
            .map { Measurement<UnitPower>(value: $0, unit: .horsepower) }
        
        let rpm: Decoded<Int> = json.get(at: Key.Motorcycle.Engine.Power.rpm.jsonKey)
        
        return Decoded.pure(curry(Motorcycle.Engine.Power.init))
            .call(power)
            .call(rpm)
    }
}

extension Motorcycle.Transmission: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Transmission> {
        return Decoded.pure(curry(Motorcycle.Transmission.init))
            .call(.pure(nil)) //gearbox
            .call(.pure(nil)) //clutch
            .call(.pure(nil)) //finalDrive
    }
}

extension Motorcycle.Frame: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Frame> {
        
        let wheelbase: Decoded<Measurement<UnitLength>> = json
            .get(at: Key.Motorcycle.Frame.wheelbase.jsonKey)
            .map { Measurement<UnitLength>(value: $0, unit: .millimeters) }
        
        let wheels: Decoded<String> = json.get(at: Key.Motorcycle.Frame.wheels.jsonKey)
        let tyres: Decoded<String> = json.get(at: Key.Motorcycle.Frame.tyres.jsonKey)
        
        return Decoded.pure(curry(Motorcycle.Frame.init))
            .call(.pure(nil)) //type
            .call(.pure(nil)) //frontSuspension
            .call(.pure(nil)) //rearSuspension
            .call(wheelbase)
            .call(wheels)
            .call(tyres)
    }
}

extension Motorcycle.Brakes: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Brakes> {
        
        let frontSize: Decoded<Measurement<UnitLength>?> = json
            .get(at: Key.Motorcycle.Brakes.frontSize.jsonKey)
            .orNil()
            .map { $0.map { Measurement<UnitLength>(value: $0, unit: .millimeters) } }
        
        let rearSize: Decoded<Measurement<UnitLength>?> = json
            .get(at: Key.Motorcycle.Brakes.rearSize.jsonKey)
            .orNil()
            .map { $0.map { Measurement<UnitLength>(value: $0, unit: .millimeters) } }
        
        return Decoded.pure(curry(Motorcycle.Brakes.init))
            .call(.pure(nil)) //type
            .call(frontSize)
            .call(rearSize)
            .call(.pure(nil)) //notes
    }
}

extension Motorcycle.CapacitiesAndPerformance: Argo.Decodable {
    
    static func decode(_ json: JSON) -> Decoded<Motorcycle.CapacitiesAndPerformance> {
        let fuelCapacity: Decoded<Measurement<UnitVolume>?> = json
            .get(at: Key.Motorcycle.CapacitiesAndPerformance.fuelCapacity.jsonKey)
            .orNil()
            .map { $0.map { Measurement<UnitVolume>(value: $0, unit: .liters) } }
        
        let lubricantCapacity: Decoded<Measurement<UnitVolume>?> = json
            .get(at: Key.Motorcycle.CapacitiesAndPerformance.lubricantCapacity.jsonKey)
            .orNil()
            .map { $0.map { Measurement<UnitVolume>(value: $0, unit: .liters) } }
        
        let weight: Decoded<Measurement<UnitMass>> = json
            .get(at: Key.Motorcycle.CapacitiesAndPerformance.weight.jsonKey)
            .map { Measurement<UnitMass>(value: $0, unit: .kilograms) }
        
        let maxSpeed: Decoded<Measurement<UnitSpeed>?> = json
            .get(at: Key.Motorcycle.CapacitiesAndPerformance.maxSpeed.jsonKey)
            .orNil()
            .map { $0.map { Measurement<UnitSpeed>(value: $0, unit: .kilometersPerHour) } }
        
        let fuelConsumption: Decoded<Measurement<UnitFuelEfficiency>?> = json
            .get(at: Key.Motorcycle.CapacitiesAndPerformance.fuelConsumption.jsonKey)
            .orNil()
            .map { $0.map { Measurement<UnitFuelEfficiency>(value: $0, unit: .litersPer100Kilometers) } }
        
        return Decoded.pure(curry(Motorcycle.CapacitiesAndPerformance.init))
            .call(fuelCapacity)
            .call(lubricantCapacity)
            .call(weight)
            .call(maxSpeed)
            .call(fuelConsumption)
    }
}

extension Texts: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Texts> {
        var languageCode = "en"
        if let unwrappedLanguageCode = Calendar.current.locale?.languageCode, unwrappedLanguageCode == "it" {
            languageCode = "it"
        }
        
        let engineConfiguration: Decoded<String> = json.get(at: [Key.Motorcycle.Engine.configuration.jsonKey, languageCode])
        let engineFeed: Decoded<String> = json.get(at: [Key.Motorcycle.Engine.feed.jsonKey, languageCode])
        let engineIgnition: Decoded<String> = json.get(at: [Key.Motorcycle.Engine.ignition.jsonKey, languageCode])
        
        let transmissionGearbox: Decoded<String> = json.get(at: [Key.Motorcycle.Transmission.gearbox.jsonKey, languageCode])
        let transmissionClutch: Decoded<String> = json.get(at: [Key.Motorcycle.Transmission.clutch.jsonKey, languageCode])
        let transmissionFinalDrive: Decoded<String> = json.get(at: [Key.Motorcycle.Transmission.finalDrive.jsonKey, languageCode])
        
        let frameType: Decoded<String> = json.get(at: [Key.Motorcycle.Frame.type.jsonKey, languageCode])
        let frameFrontSuspension: Decoded<String> = json.get(at: [Key.Motorcycle.Frame.frontSuspension.jsonKey, languageCode])
        let frameRearSuspension: Decoded<String> = json.get(at: [Key.Motorcycle.Frame.rearSuspension.jsonKey, languageCode])
        
        let brakesType: Decoded<String> = json.get(at: [Key.Motorcycle.Brakes.type.jsonKey, languageCode])
        let brakesNotes: Decoded<String?> = json.get(at: [Key.Motorcycle.Brakes.notes.jsonKey, languageCode]).orNil()
        
        let notes: Decoded<String?> = json.get(at: [Key.Motorcycle.notes.jsonKey, languageCode]).orNil()
        
        
        return Decoded.pure(curry(Texts.init))
            .call(engineConfiguration)
            .call(engineFeed)
            .call(engineIgnition)
            .call(transmissionGearbox)
            .call(transmissionClutch)
            .call(transmissionFinalDrive)
            .call(frameType)
            .call(frameFrontSuspension)
            .call(frameRearSuspension)
            .call(brakesType)
            .call(brakesNotes)
            .call(notes)
    }
}

extension JsonFile: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<JsonFile> {
        return Decoded.pure(curry(JsonFile.init))
            .call(json.get(at: Key.JsonFile.version))
            .call(json.get(at: Key.JsonFile.elements))
            .call(json.get(at: Key.JsonFile.texts))
    }
}

extension URL: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<URL> {
        guard case .string(let path) = json else {
            return Decoded.failure(.typeMismatch(expected: "String", actual: "\(json)"))
        }
        guard let url = URL(string: path) else {
            return Decoded.failure(.custom("Cannot create URL from string \(path)"))
        }
        return Decoded.success(url)
    }
}

extension Decoded {
    static func materialize(_ throwing: () throws -> T) -> Decoded {
        return Argo.materialize(throwing)
    }
}

extension Decoded {
    func orNil() -> Decoded<T?> {
        switch self {
        case let .success(value):
            return .success(Optional(value))
        case .failure(_):
            return .success(nil)
        }
    }
}

//extension Optional: Argo.Decodable where Wrapped: Argo.Decodable, Wrapped.DecodedType == Wrapped {
//    public typealias DecodedType = Optional
//
//    public static func decode(_ json: JSON) -> Decoded<Optional<Wrapped>> {
//        if case .null = json {
//            return .success(nil)
//        }
//
//        return Wrapped.decode(json).map { Optional($0) }
//    }
//}

extension Array: Argo.Decodable where Element: Argo.Decodable, Element.DecodedType == Element {
    public typealias DecodedType = Array
    
    public static func decode(_ json: JSON) -> Decoded<Array> {
        guard case let .array(array) = json else {
            return .typeMismatch(expected: "array", actual: json)
        }
        
        return .materialize {
            try array.map { internalJson in
                try Element.decode(internalJson).dematerialize()
            }
        }
    }
}

extension Dictionary: Argo.Decodable where Key == String, Value: Argo.Decodable, Value.DecodedType == Value {
    public typealias DecodedType = Dictionary
    
    public static func decode(_ json: JSON) -> Decoded<Dictionary<Key, Value>> {
        guard case let .object(dict) = json else {
            return .typeMismatch(expected: "object", actual: json)
        }

        return .materialize {
            try dict.mapValues { internalJson in
                try Value.decode(internalJson).dematerialize()
            }
        }
    }
}

// MARK: - Conforming to CellRepresentable protocol

extension RowElement: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleInfoCell.defaultIdentifier)
                            .getOrElse(MotorcycleInfoCell.getCell()) as! MotorcycleInfoCell
        return cell.set(withRowElement: self)
    }
}

extension RowNote: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleNotesCell.defaultIdentifier)
                            .getOrElse(MotorcycleNotesCell.getCell()) as! MotorcycleNotesCell
        return cell.set(withRowNote: self)
    }
}

extension RowImage: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleImagesCell.defaultIdentifier)
                            .getOrElse(MotorcycleImagesCell.getCell()) as! MotorcycleImagesCell
        return cell.setText(withElementNumber: self.urls.count)
    }
    
    var selectionBehavior: CellSelection {
        return .showImages(imageURLs: urls)
    }
}

extension URL: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.defaultIdentifier)
                            .getOrElse(ImageCell.getCell()) as! ImageCell
        return cell.set(withImageURL: self)
    }
}

// MARK: - Getting the specs strings for MotorcycleInfoCell

extension Motorcycle.GeneralInfo {
    var getFamilyString: String { return family ?? "---" }
    var getNameString: String { return name }
    var getFirstYearString: String { return firstYear.description }
    var getLastYearString: String { return lastYear?.description ?? "..." }
}

extension Motorcycle.Engine {
    var getConfigurationString: String { return configuration ?? "---" }
    var getCompressionString: String { return "\(compression) : 1" }
    var getPowerString: String { return power?.formattedValue ?? "---" }
    var getFeedString: String { return feed ?? "---" }
    var getIgnitionString: String { return ignition ?? "---" }
    var getBoreString: String { return bore.description }
    var getStrokeString: String { return stroke.description }
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
    var getWheelbaseString: String { return wheelbase.descriptionWithDecimalsIfPresent }
    var getWheelsString: String { return wheels }
    var getTyresString: String { return tyres }
}

extension Motorcycle.Brakes {
    var getTypeString: String { return type ?? "---" }
    var getFrontSizeString: String { return frontSize?.descriptionWithDecimalsIfPresent ?? "---" }
    var getRearSizeString: String { return rearSize?.descriptionWithDecimalsIfPresent ?? "---" }
    var getNotesString: String { return notes ?? "---" }
}

extension Motorcycle.CapacitiesAndPerformance {
    var getFuelCapacityString: String { return fuelCapacity?.descriptionWithDecimalsIfPresent ?? "---" }
    var getLubricantCapacityString: String { return lubricantCapacity?.descriptionWithDecimalsIfPresent ?? "---" }
    var getWeightString: String { return weight.descriptionWithDecimalsIfPresent }
    var getMaxSpeedString: String { return maxSpeed?.descriptionWithDecimalsIfPresent ?? "---" }
    var getFuelConsumptionString: String { return fuelConsumption?.description ?? "---" }
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

extension Motorcycle {
    func createArrayfromStruct() -> [SectionData] {
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

// MARK: - Utility extensions

extension Optional {
    func getOrElse(_ elseValue: @autoclosure () -> Wrapped ) -> Wrapped {
        switch self {
        case .none:
            return elseValue()
        case .some(let value):
            return value
        }
    }
}

extension UnitVolume {
    static let engineCubicCentimeters = UnitVolume(symbol: "cc", converter: UnitConverterLinear(coefficient: 0.001))
    static let engineCubicInches = UnitVolume(symbol: "cu in", converter: UnitConverterLinear(coefficient: 0.016387064))
}

extension Measurement {    
    var descriptionWithDecimalsIfPresent: String {
        let roundedValue = self.value.rounded(.down)
        guard (self.value - roundedValue).isZero else { return description }
        return String(format: "%.0f", self.value) + " " + self.unit.symbol
    }
}

extension Double {
    var descriptionWithDecimalsIfPresent: String {
        let roundedValue = self.rounded(.down)
        guard (self - roundedValue).isZero else { return description }
        return String(format: "%.0f", self)
    }
}

// MARK: - Comparator extensions

// Extending Comparable to implement Comparator
extension Comparable {
    static func comparator(ascending: Bool = true) -> Comparator<Self> {
        return Comparator.init { lhs, rhs in
            if ascending { return lhs < rhs ? .lt : lhs > rhs ? .gt : .eq }
            return lhs < rhs ? .gt : lhs > rhs ? .lt : .eq
        }
    }
}

// Extending Optional to implement Comparator
// Necessary for optional properties
// nil elements are moved at the end of the list
extension Optional where Wrapped: Comparable {
    
    /// Returns a comparator where nil elements are moved at the end of the list
    static func comparator(ascending: Bool = true) -> Comparator<Optional> {
        return Comparator.init { lhs, rhs in
            switch (lhs, rhs) {
            case (.none, _):
                return .gt
            case (_, .none):
                return .lt
            case (let left?, let right?):
                if ascending { return left < right ? .lt : left > right ? .gt : .eq }
                return left < right ? .gt : left > right ? .lt : .eq
            }
        }
    }
}

extension Collection where Element: Equatable {
    
    /// Check if `self` and `array` have at least one element in common and
    /// returns the index of the first common element in `self`, `nil` if no
    /// common elements are found.
    /// - parameter array: The array to be compared to `self`.
    /// - returns: the index of the first common element in `self`, `nil` if
    /// no common elements are found.
    func index(fromFirstMatch array: [Element]) -> Index? {
        for element in array {
            if let index = index(of: element) {
                return index
            }
        }
        return nil
    }
}

extension Array {
    
    /// Replace the element at index `index` with `newElement` and returns the old element.
    /// - parameter newElement: the element that replaces the old one
    /// - parameter index: the index locating the old element
    /// - returns: the old element
    mutating func replaceElement(with newElement: Element, at index: Index) -> Element {
        let oldElement = remove(at: index)
        insert(newElement, at: index)
        return oldElement
    }
}

extension Array {
    
    /// Sort the elements in place using `comparator` as the comparing function.
    /// - parameter comparator: the `Comparator<Element>` that handles the comparison
    mutating func sort(by comparator: Comparator<Element>) {
        self.sort { comparator.call(($0, $1)) == .lt }
    }
}

extension Array {
    
    /// returns `self` with the new element appended at the end
    /// - parameter element: the element to be appended
    /// - returns: `self` with `element` appended at the end
    func appending (_ element: Element) -> Array {
        var mutatingSelf = self
        mutatingSelf.append(element)
        return mutatingSelf
    }
}

extension Array where Element: Comparable {
    
    /// Sort the elements and remove duplicates.
    /// - returns: the array sorted and without duplicates
    func removeDuplicates() -> Array {
        return self
            .sorted() { $0 < $1 }
            .reduce([]) { (accumulator, element) in
                if let last = accumulator.last, last == element {
                    return accumulator
                } else {
                    return accumulator.appending(element)
                }
        }
    }
}

// MARK: - UIColor extension

// Colors used in the app
extension UIColor {
    static let legnanoGreen = UIColor(displayP3Red: 181.0/255.0, green: 208.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    static let lightLegnanoGreen = UIColor(displayP3Red: 238.0/255.0, green: 244.0/255.0, blue: 215.0/255.0, alpha: 1)
    static let guzziRed = UIColor(displayP3Red: 195.0/255.0, green: 21.0/255.0, blue: 26.0/255.0, alpha: 1.0)
}

// MARK: - UISearchBar text field appearance customization methods

extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    /// Returns the text field of the search bar
    func getTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    /// Set the placeholder text and text color
    /// - parameter text: the text for the placeholder
    /// - parameter color: the color for the placeholder text
    func setPlaceholderText(_ text: String, withColor color: UIColor) {
        if let textField = getTextField() {
            textField.attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [.foregroundColor: color]
            )
        }
    }
    
    /// Set the search icon color in the search bar's text field
    /// - parameter color: the new color for the search icon
    func setIconColor(_ color: UIColor) {
        if let imageView = getTextField()?.leftView as? UIImageView,
            let newImage = imageView.image?.transform(withNewColor: color) {
            imageView.image = newImage
        }
    }
    
    func setClearButtonColor(_ color: UIColor) {
        if let textField = getTextField(),
            let button = textField.value(forKey: "clearButton") as? UIButton,
            let image = button.imageView?.image {
            button.setImage(image.transform(withNewColor: color), for: .normal)
        }
        
//        if let textField = getTextField(),
//            let button = textField.value(forKey: "clearButton") as? UIButton {
//            let templateImage = button.imageView?.image?.withRenderingMode(.alwaysTemplate)
//            button.setImage(templateImage, for: .normal)
//            button.tintColor = color
//        }
    }
}

extension UIImage {
    
    /// Change the color of self
    /// - parameter color: the new color for self
    /// - returns: a new instance of self with the new color, nil if the transformation fails.
    func transform(withNewColor color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension UIViewController {
    func handle(cellSelection: CellSelection, nextViewControllerTitle: String) {
        switch cellSelection {
        case .ignored:
            break
        case let .showImages(imageURLs):
            navigationController?.pushViewController(ImagesViewController(motorcycleName: nextViewControllerTitle,
                                                                          imagesUrls: imageURLs,
                                                                          nibName: "ImagesViewController",
                                                                          bundle: nil),
                                                     animated: true)
        }
    }
}




















