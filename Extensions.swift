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

extension Motorcycle: Decodable {
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

extension Motorcycle.GeneralInfo: Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.GeneralInfo> {
        return curry(Motorcycle.GeneralInfo.init)
            <^> json <|? Key.Motorcycle.GeneralInfo.family.jsonKey
            <*> json <| Key.Motorcycle.GeneralInfo.name.jsonKey
            <*> json <| Key.Motorcycle.GeneralInfo.firstYear.jsonKey
            <*> json <|? Key.Motorcycle.GeneralInfo.lastYear.jsonKey
    }
}

extension Motorcycle.Engine: Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Engine> {
        return curry(Motorcycle.Engine.init)
            <^> json <| Key.Motorcycle.Engine.configuration.jsonKey
            <*> json <| Key.Motorcycle.Engine.strokeCycle.jsonKey
            <*> json <| Key.Motorcycle.Engine.bore.jsonKey
            <*> json <| Key.Motorcycle.Engine.stroke.jsonKey
            <*> json <| Key.Motorcycle.Engine.displacement.jsonKey
            <*> json <| Key.Motorcycle.Engine.compression.jsonKey
            <*> json <|? Key.Motorcycle.Engine.Power.jsonKey
            <*> json <| Key.Motorcycle.Engine.feedSystem.jsonKey
    }
}

extension Motorcycle.Engine.StrokeCycle: Decodable { }

extension Motorcycle.Engine.Power: Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Engine.Power> {
        return curry(Motorcycle.Engine.Power.init)
            <^> json <| Key.Motorcycle.Engine.Power.peak.jsonKey
            <*> json <| Key.Motorcycle.Engine.Power.rpm.jsonKey
    }
}

extension Motorcycle.Frame: Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Frame> {
        return curry(Motorcycle.Frame.init)
            <^> json <| Key.Motorcycle.Frame.type.jsonKey
            <*> json <| Key.Motorcycle.Frame.frontSuspension.jsonKey
            <*> json <| Key.Motorcycle.Frame.rearSuspension.jsonKey
            <*> json <| Key.Motorcycle.Frame.wheelbase.jsonKey
            <*> json <| Key.Motorcycle.Frame.brakes.jsonKey
    }
}

extension Motorcycle.CapacitiesAndPerformance: Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.CapacitiesAndPerformance> {
        return curry(Motorcycle.CapacitiesAndPerformance.init)
            <^> json <|? Key.Motorcycle.CapacitiesAndPerformance.fuelCapacity.jsonKey
            <*> json <|? Key.Motorcycle.CapacitiesAndPerformance.lubricantCapacity.jsonKey
            <*> json <| Key.Motorcycle.CapacitiesAndPerformance.weight.jsonKey
            <*> json <|? Key.Motorcycle.CapacitiesAndPerformance.maxSpeed.jsonKey
            <*> json <|? Key.Motorcycle.CapacitiesAndPerformance.fuelConsumption.jsonKey
    }
}


extension URL: Decodable {
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

extension JsonFile: Decodable {
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

// MARK: - Conforming to ArrayConvertible protocol

extension Motorcycle.GeneralInfo: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.append(RowElement(rowKey: Key.Motorcycle.GeneralInfo.family.guiKey,
                                   rowValue: convertOptionalToString(family)))
        elements.append(RowElement(rowKey: Key.Motorcycle.GeneralInfo.name.guiKey,
                                   rowValue: name))
        elements.append(RowElement(rowKey: Key.Motorcycle.GeneralInfo.firstYear.guiKey,
                                   rowValue: String(firstYear)))
        elements.append(RowElement(rowKey: Key.Motorcycle.GeneralInfo.lastYear.guiKey,
                                   rowValue: convertOptionalToString(lastYear)))
        return elements
    }
}

extension Motorcycle.Engine: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.configuration.guiKey,
                                   rowValue: configuration))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.strokeCycle.guiKey,
                                   rowValue: String(strokeCycle.rawValue)))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.bore.guiKey,
                                   rowValue: String(bore)))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.stroke.guiKey,
                                   rowValue: String(stroke)))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.displacement.guiKey,
                                   rowValue: String(displacement)))
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.compression.guiKey,
                                   rowValue: "\(compression) : 1"))
        if let unwrapPower = power {
            elements.append(RowElement(rowKey: Key.Motorcycle.Engine.Power.guiKey,
                                       rowValue: unwrapPower.formattedValue))
        } else {
            elements.append(RowElement(rowKey: Key.Motorcycle.Engine.Power.guiKey,
                                       rowValue: "N/A"))
        }
        
        elements.append(RowElement(rowKey: Key.Motorcycle.Engine.feedSystem.guiKey,
                                   rowValue: feedSystem))
        return elements
    }
}

extension Motorcycle.Frame: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.type.guiKey,
                                   rowValue: type))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.frontSuspension.guiKey,
                                   rowValue: frontSuspension))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.rearSuspension.guiKey,
                                   rowValue: rearSuspension))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.wheelbase.guiKey,
                                   rowValue: String(wheelbase)))
        elements.append(RowElement(rowKey: Key.Motorcycle.Frame.brakes.guiKey,
                                   rowValue: brakes))
        return elements
    }
}

extension Motorcycle.CapacitiesAndPerformance: ArrayConvertible {
    func convertToArray() -> [CellRepresentable] {
        var elements: [RowElement] = []
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.fuelCapacity.guiKey,
                                   rowValue: convertOptionalToString(fuelCapacity)))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.lubricantCapacity.guiKey,
                                   rowValue: convertOptionalToString(lubricantCapacity)))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.weight.guiKey,
                                   rowValue: String(weight)))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.maxSpeed.guiKey,
                                   rowValue: convertOptionalToString(maxSpeed)))
        elements.append(RowElement(rowKey: Key.Motorcycle.CapacitiesAndPerformance.fuelConsumption.guiKey,
                                   rowValue: convertOptionalToString(fuelConsumption)))
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
