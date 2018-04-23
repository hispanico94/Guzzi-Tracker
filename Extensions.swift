//
//  Extensions.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 28/02/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import UIKit
import Argo
import Runes
import Curry

// MARK: - Conforming to Decodable protocol

extension Motorcycle: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle> {
        return curry(Motorcycle.init)
            <^> json <| Key.Motorcycle.id.jsonKey
            <*> json <| Key.Motorcycle.GeneralInfo.jsonKey
            <*> json <| Key.Motorcycle.Engine.jsonKey
            <*> json <| Key.Motorcycle.Frame.jsonKey
            <*> json <| Key.Motorcycle.CapacitiesAndPerformance.jsonKey
            <*> json <|? Key.Motorcycle.notes.jsonKey
            <*> json <||? Key.Motorcycle.images.jsonKey
    }
}

extension Motorcycle.GeneralInfo: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.GeneralInfo> {
        return curry(Motorcycle.GeneralInfo.init)
            <^> json <|? Key.Motorcycle.GeneralInfo.family.jsonKey
            <*> json <| Key.Motorcycle.GeneralInfo.name.jsonKey
            <*> json <| Key.Motorcycle.GeneralInfo.firstYear.jsonKey
            <*> json <|? Key.Motorcycle.GeneralInfo.lastYear.jsonKey
    }
}

extension Motorcycle.Engine: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Engine> {
        let configuration: Decoded<String> = json <| Key.Motorcycle.Engine.configuration.jsonKey
        let strokeCycle: Decoded<StrokeCycle> = json <| Key.Motorcycle.Engine.strokeCycle.jsonKey
        let boreDouble: Decoded<Double> = json <| Key.Motorcycle.Engine.bore.jsonKey
        let strokeDouble: Decoded<Double> = json <| Key.Motorcycle.Engine.stroke.jsonKey
        let displacementDouble: Decoded<Double> = json <| Key.Motorcycle.Engine.displacement.jsonKey
        let compression: Decoded<Double> = json <| Key.Motorcycle.Engine.compression.jsonKey
        let power: Decoded<Power?> = json <|? Key.Motorcycle.Engine.Power.jsonKey
        let feedSystem: Decoded<String> = json <| Key.Motorcycle.Engine.feedSystem.jsonKey
        
        let bore = boreDouble.map { Measurement<UnitLength>(value: $0, unit: .millimeters) }
        let stroke = strokeDouble.map { Measurement<UnitLength>(value: $0, unit: .millimeters) }
        let displacement = displacementDouble.map { Measurement<UnitVolume>(value: $0, unit: .engineCubicCentimeters) }
        
        return curry(Motorcycle.Engine.init)
            <^> configuration
            <*> strokeCycle
            <*> bore
            <*> stroke
            <*> displacement
            <*> compression
            <*> power
            <*> feedSystem
    }
}

extension Motorcycle.Engine.StrokeCycle: Argo.Decodable { }

extension Motorcycle.Engine.Power: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Engine.Power> {
        
        let powerDouble: Decoded<Double> = json <| Key.Motorcycle.Engine.Power.peak.jsonKey
        let rpm: Decoded<Int> = json <| Key.Motorcycle.Engine.Power.rpm.jsonKey
        
        let power = powerDouble.map { Measurement<UnitPower>(value: $0, unit: .horsepower) }
        
        return curry(Motorcycle.Engine.Power.init)
            <^> power
            <*> rpm
    }
}

extension Motorcycle.Frame: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Frame> {
        let type: Decoded<String> = json <| Key.Motorcycle.Frame.type.jsonKey
        let frontSuspension: Decoded<String> = json <| Key.Motorcycle.Frame.frontSuspension.jsonKey
        let rearSuspension: Decoded<String> = json <| Key.Motorcycle.Frame.rearSuspension.jsonKey
        let wheelbaseDouble: Decoded<Double> = json <| Key.Motorcycle.Frame.wheelbase.jsonKey
        let brakes: Decoded<String> = json <| Key.Motorcycle.Frame.brakes.jsonKey
        
        let wheelbase = wheelbaseDouble.map { Measurement<UnitLength>(value: $0, unit: .millimeters) }
        
        return curry(Motorcycle.Frame.init)
            <^> type
            <*> frontSuspension
            <*> rearSuspension
            <*> wheelbase
            <*> brakes
    }
}

extension Motorcycle.CapacitiesAndPerformance: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.CapacitiesAndPerformance> {
        let fuelCapacityDouble: Decoded<Double?> = json <|? Key.Motorcycle.CapacitiesAndPerformance.fuelCapacity.jsonKey
        let lubricantCapacityDouble: Decoded<Double?> = json <|? Key.Motorcycle.CapacitiesAndPerformance.lubricantCapacity.jsonKey
        let weightDouble: Decoded<Double> = json <| Key.Motorcycle.CapacitiesAndPerformance.weight.jsonKey
        let maxSpeedDouble: Decoded<Double?> = json <|? Key.Motorcycle.CapacitiesAndPerformance.maxSpeed.jsonKey
        let fuelConsumptionDouble: Decoded<Double?> = json <|? Key.Motorcycle.CapacitiesAndPerformance.fuelConsumption.jsonKey
        
        let fuelCapacity = fuelCapacityDouble.map { $0.map { Measurement<UnitVolume>(value: $0, unit: .liters) } }
        let lubricantCapacity = lubricantCapacityDouble.map { $0.map { Measurement<UnitVolume>(value: $0, unit: .liters) } }
        let weight = weightDouble.map { Measurement<UnitMass>(value: $0, unit: .kilograms) }
        let maxSpeed = maxSpeedDouble.map { $0.map { Measurement<UnitSpeed>(value: $0, unit: .kilometersPerHour) } }
        let fuelConsumption = fuelConsumptionDouble.map { $0.map { Measurement<UnitFuelEfficiency>(value: $0, unit: .litersPer100Kilometers) } }
        
        return curry(Motorcycle.CapacitiesAndPerformance.init)
            <^> fuelCapacity
            <*> lubricantCapacity
            <*> weight
            <*> maxSpeed
            <*> fuelConsumption
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

extension JsonFile: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<JsonFile> {
        return curry(JsonFile.init)
            <^> json <| Key.JsonFile.version
            <*> json <| Key.JsonFile.totalElements
            <*> json <|| Key.JsonFile.elements
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
    var getConfigurationString: String { return configuration }
    var getCompressionString: String { return "\(compression) : 1" }
    var getPowerString: String { return power?.formattedValue ?? "---" }
    var getFeedSystemString: String { return feedSystem }
    
    func getBoreString() -> String {
        return bore.description
    }
    
    func getStrokeString() -> String {
        return stroke.description
    }
    
    func getDisplacementString() -> String {
        return displacement.description
    }
}

extension Motorcycle.Frame {
    var getTypeString: String { return type }
    var getFrontSuspensionString: String { return frontSuspension }
    var getRearSuspensionString: String { return rearSuspension }
    var getBrakesString: String { return brakes }
    
    func getWheelbaseString() -> String {
        return Int(wheelbase.value).description + " " + wheelbase.unit.symbol
    }
}

extension Motorcycle.CapacitiesAndPerformance {
    func getFuelCapacityString() -> String {
        return fuelCapacity?.description ?? "---"
    }
    
    func getLubricantCapacityString() -> String {
        return lubricantCapacity?.description ?? "---"
    }
    
    func getWeightString() -> String {
        return Int(weight.value).description + " " + weight.unit.symbol
    }
    
    func getMaxSpeedString() -> String {
        guard let unwrappedMaxSpeed = maxSpeed else { return "---" }
        return Int(unwrappedMaxSpeed.value).description + " " + unwrappedMaxSpeed.unit.symbol
    }
    
    func getFuelConsumptionString() -> String {
        return fuelConsumption?.description ?? "---"
    }
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
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.configuration.guiKey,
                                   rowValue: getConfigurationString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.bore.guiKey,
                                   rowValue: getBoreString()))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.stroke.guiKey,
                                   rowValue: getStrokeString()))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.displacement.guiKey,
                                   rowValue: getDisplacementString()))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.compression.guiKey,
                                   rowValue: getCompressionString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.Power.guiKey,
                                   rowValue: getPowerString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.feedSystem.guiKey,
                                   rowValue: getFeedSystemString))
        return elements
    }
}

extension Motorcycle.Frame: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.type.guiKey,
                                   rowValue: getTypeString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.frontSuspension.guiKey,
                                   rowValue: getFrontSuspensionString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.rearSuspension.guiKey,
                                   rowValue: getRearSuspensionString))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.wheelbase.guiKey,
                                   rowValue: getWheelbaseString()))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.brakes.guiKey,
                                   rowValue: getBrakesString))
        return elements
    }
}

extension Motorcycle.CapacitiesAndPerformance: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.fuelCapacity.guiKey,
                                   rowValue: getFuelCapacityString()))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.lubricantCapacity.guiKey,
                                   rowValue: getLubricantCapacityString()))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.weight.guiKey,
                                   rowValue: getWeightString()))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.maxSpeed.guiKey,
                                   rowValue: getMaxSpeedString()))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.fuelConsumption.guiKey,
                                   rowValue: getFuelConsumptionString()))
        return elements
    }
}

extension Motorcycle {
    func createArrayfromStruct() -> [SectionData] {
        var elements: [SectionData] = []
        elements.append(SectionData(sectionName: Key.Motorcycle.GeneralInfo.guiKey,
                                    sectionElements: generalInfo.convertToArray()))
        elements.append(SectionData(sectionName: Key.Motorcycle.Engine.guiKey,
                                    sectionElements: engine.convertToArray()))
        elements.append(SectionData(sectionName: Key.Motorcycle.Frame.guiKey,
                                    sectionElements: frame.convertToArray()))
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

// MARK: - utility extensions

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


