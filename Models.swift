//
//  Models.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 28/02/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import Foundation

enum StrokeCycle: Int {
    case twoStroke = 2
    case fourStroke = 4
}

struct EnginePower {
    let peak: Double
    let rpm: Int
    var formattedValue: String {
        return "\(peak) hp at \(rpm)"
    }
}

struct Engine {
    let configuration: String
    let strokeCycle: StrokeCycle
    let bore: Double
    let stroke: Double
    let displacement: Double
    let compression: Double
    let power: EnginePower?
    let feedSystem: String
}

struct Frame {
    let type: String
    let suspensions: String
    let wheelbase: Int
    let brakes: String
}

struct Motorcycle {
    let id: Int
    let family: String?
    let name: String
    let firstYear: Int
    let lastYear: Int?
    let engine: Engine
    let frame: Frame
    let weight: Int
    let maxSpeed: Int?
    let notes: String?
}

struct JsonFile {
    let version: Int
    let totalElements: Int
    let elements: [Motorcycle]
}





