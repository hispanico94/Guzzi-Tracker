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

extension StrokeCycle: Decodable { }

extension EnginePower: Decodable {
    static func decode(_ json: JSON) -> Decoded<EnginePower> {
        return curry(EnginePower.init)
            <^> json <| "peak"
            <*> json <| "rpm"
    }
}

extension Engine: Decodable {
    static func decode(_ json: JSON) -> Decoded<Engine> {
        return curry(Engine.init)
            <^> json <| "configuration"
            <*> json <| "stroke_cycle"
            <*> json <| "bore"
            <*> json <| "stroke"
            <*> json <| "displacement"
            <*> json <| "compression"
            <*> json <|? "power"
            <*> json <| "feed_system"
    }
}

extension Frame: Decodable {
    static func decode(_ json: JSON) -> Decoded<Frame> {
        return curry(Frame.init)
            <^> json <| "type"
            <*> json <| "suspensions"
            <*> json <| "wheelbase"
            <*> json <| "brakes"
    }
}

extension Motorcycle: Decodable {
    static func decode(_ json: JSON) -> Decoded<Motorcycle> {
        return curry(Motorcycle.init)
            <^> json <| "id"
            <*> json <|? "family"
            <*> json <| "name"
            <*> json <| "first_year"
            <*> json <|? "last_year"
            <*> json <| "engine"
            <*> json <| "frame"
            <*> json <| "weight"
            <*> json <|? "max_speed"
            <*> json <|? "notes"
    }
}

extension JsonFile: Decodable {
    static func decode(_ json: JSON) -> Decoded<JsonFile> {
        return curry(JsonFile.init)
            <^> json <| "version"
            <*> json <| "total_elements"
            <*> json <|| "elements"
    }
}

