//
//  MotorcycleJson.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 02/08/2019.
//  Copyright © 2019 PaoloRocca. All rights reserved.
//

import Foundation

struct MotorcycleJson: Decodable {
    let id: Int
    let general_info: GeneralInfo
    let engine: Engine
    let transmission: Transmission
    let frame: Frame
    let brakes: Brakes
    let capacities_performances: CapacitiesAndPerformance
    let notes: String? //optional(text)
    let images: [URL]?
    
    struct GeneralInfo: Decodable {
        let family: String?
        let name: String
        let first_year: Int
        let last_year: Int?
    }
    
    struct Engine: Decodable {
        let configuration: String? //text
        let stroke_cycle: StrokeCycle
        let bore: Double
        let stroke: Double
        let displacement: Displacement
        let compression: Double
        let power: Power?
        let feed: String? //text
        let ignition: String? //text
        
        enum StrokeCycle: Int, Decodable {
            case twoStroke = 2
            case fourStroke = 4
        }
        
        struct Displacement: Decodable {
            let real: Double
            let nominal: Double
        }
        
        struct Power: Decodable {
            let peak: Double
            let rpm: Int
        }
    }
    
    struct Transmission: Decodable {
        let gearbox: String? //text
        let clutch: String? //text
        let final_drive: String? //text
    }
    
    struct Frame: Decodable {
        let type: String? //text
        let front_suspension: String? //text
        let rear_suspension: String? //text
        let wheelbase: Double
        let wheels: String
        let tyres: String
    }
    
    struct Brakes: Decodable {
        let type: String? //text
        let front_size: Double?
        let rear_size: Double?
        let notes: String? //optional(text)
    }
    
    struct CapacitiesAndPerformance: Decodable {
        let fuel_capacity: Double?
        let lubricant_capacity: Double?
        let weight: Double
        let max_speed: Double?
        let fuel_consumption: Double?
    }
}

extension MotorcycleJson {
    func getMotorcycle(with texts: Texts?) -> Motorcycle {
        let generalInfo = Motorcycle.GeneralInfo(
            family: self.general_info.family,
            name: self.general_info.name,
            firstYear: self.general_info.first_year,
            lastYear: self.general_info.last_year
        )
        
        let engine = Motorcycle.Engine(
            configuration: texts?.engine_configuration.string,
            strokeCycle: Motorcycle.Engine.StrokeCycle(rawValue: self.engine.stroke_cycle.rawValue)!,
            bore: Measurement(value: self.engine.bore, unit: .millimeters),
            stroke: Measurement(value: self.engine.stroke, unit: .millimeters),
            displacement: Motorcycle.Engine.Displacement(
                real: Measurement(value: self.engine.displacement.real, unit: .cubicCentimeters),
                nominal: Measurement(value: self.engine.displacement.nominal, unit: .cubicCentimeters)
            ),
            compression: self.engine.compression,
            power: self.engine.power.map {
                Motorcycle.Engine.Power(peak: Measurement(value: $0.peak, unit: .horsepower), rpm: $0.rpm)
            },
            feed: texts?.engine_feed.string,
            ignition: texts?.engine_ignition.string
        )
        
        let transmission = Motorcycle.Transmission(
            gearbox: texts?.transmission_gearbox.string,
            clutch: texts?.transmission_clutch.string,
            finalDrive: texts?.transmission_final_drive.string
        )
        
        let frame = Motorcycle.Frame(
            type: texts?.frame_type.string,
            frontSuspension: texts?.frame_front_suspension.string,
            rearSuspension: texts?.frame_rear_suspension.string,
            wheelbase: Measurement(value: self.frame.wheelbase, unit: .millimeters),
            wheels: self.frame.wheels,
            tyres: self.frame.tyres
        )
        
        let brakes = Motorcycle.Brakes(
            type: texts?.brakes_type.string,
            frontSize: self.brakes.front_size.map { Measurement(value: $0, unit: .millimeters) },
            rearSize: self.brakes.rear_size.map { Measurement(value: $0, unit: .millimeters) },
            notes: texts?.brakes_notes.string
        )
        
        let capacitiesAndPerformance = Motorcycle.CapacitiesAndPerformance(
            fuelCapacity: self.capacities_performances.fuel_capacity.map { Measurement(value: $0, unit: .liters) },
            lubricantCapacity: self.capacities_performances.lubricant_capacity.map{ Measurement(value: $0, unit: .liters) },
            weight: Measurement(value: self.capacities_performances.weight, unit: .kilograms),
            maxSpeed: self.capacities_performances.max_speed.map { Measurement(value: $0, unit: .kilometersPerHour) },
            fuelConsumption: self.capacities_performances.fuel_consumption.map { Measurement(value: $0, unit: .litersPer100Kilometers) }
        )
        
        return Motorcycle(
            id: self.id,
            generalInfo: generalInfo,
            engine: engine,
            transmission: transmission,
            frame: frame,
            brakes: brakes,
            capacitiesAndPerformance: capacitiesAndPerformance,
            notes: texts?.notes.string,
            images: self.images
        )
    }
}
