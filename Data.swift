//
//  Data.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 01/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import Foundation
import Argo

func getMotorcycleListFromJson() throws -> [Motorcycle] {
    guard
        let jsonURL = Bundle.main.url(forResource: "info_moto", withExtension: "json"),
        let jsonData = try? Data(contentsOf: jsonURL),
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    else { return [] }
    
    let file: Decoded<JsonFile> = decode(json)
    var decodedMoto: [Motorcycle]
    
    switch file {
    case .success(let decodedFile):
        decodedMoto = decodedFile.elements
    case .failure(let error):
        throw error
    }
    return decodedMoto
}

extension Motorcycle.GeneralInfo: ArrayConvertible {
    func convertToArray() -> [RowElement] {
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
    func convertToArray() -> [RowElement] {
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
    func convertToArray() -> [RowElement] {
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
    func convertToArray() -> [RowElement] {
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

extension Motorcycle.Other: ArrayConvertible {
    func convertToArray() -> [RowElement] {
        var elements: [RowElement] = []
        elements.append(RowElement(rowKey: Key.Motorcycle.Other.notes.guiKey,
                                   rowValue: convertOptionalToString(notes)))
        elements.append(RowElement(rowKey: Key.Motorcycle.Other.images.guiKey,
                                   rowValue: "Images"))
        return elements
    }
}

extension Motorcycle {
    func createArrayfromStruct() -> [(String, [RowElement])] {
        var elements: [(String, [RowElement])] = []
        elements.append((Key.Motorcycle.GeneralInfo.guiKey, generalInfo.convertToArray()))
        elements.append((Key.Motorcycle.Engine.guiKey, engine.convertToArray()))
        elements.append((Key.Motorcycle.Frame.guiKey, frame.convertToArray()))
        elements.append((Key.Motorcycle.CapacitiesAndPerformance.guiKey, capacitiesAndPerformance.convertToArray()))
        elements.append((Key.Motorcycle.Other.guiKey, otherInfo.convertToArray()))
        return elements
    }
}


