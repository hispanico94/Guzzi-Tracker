//
//  Extensions.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 28/02/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

extension Motorcycle: Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle> {
        return curry(Motorcycle.init)
            <^> json <| Key.Motorcycle.id.jsonKey
            <*> json <| Key.Motorcycle.GeneralInfo.jsonKey
            <*> json <| Key.Motorcycle.Engine.jsonKey
            <*> json <| Key.Motorcycle.Frame.jsonKey
            <*> json <| Key.Motorcycle.CapacitiesAndPerformance.jsonKey
            <*> json <| Key.Motorcycle.Other.jsonKey
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

extension Motorcycle.Other: Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle.Other> {
        return curry(Motorcycle.Other.init)
            <^> json <|? Key.Motorcycle.Other.notes.jsonKey
            <*> json <||? Key.Motorcycle.Other.images.jsonKey
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

