//
//  Key.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 21/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import Foundation

struct Key {
    
    struct Motorcycle {
        static let id = JsonOrGUIKey(jsonKey: "id", guiKey: "")
        static let notes = JsonOrGUIKey(jsonKey: "notes", guiKey: "Notes")
        static let images = JsonOrGUIKey(jsonKey: "images", guiKey: "Images")
        
        
        struct GeneralInfo {
            static let jsonKey = "general_info"
            static let guiKey = "General Info"
            
            static let family = JsonOrGUIKey(jsonKey: "family", guiKey: "Family")
            static let name = JsonOrGUIKey(jsonKey: "name", guiKey: "Name")
            static let firstYear = JsonOrGUIKey(jsonKey: "first_year", guiKey: "Introduced")
            static let lastYear = JsonOrGUIKey(jsonKey: "last_year", guiKey: "Discontinued")
        }
        
        struct Engine {
            static let jsonKey = "engine"
            static let guiKey = "Engine Characteristics"
            
            static let configuration = JsonOrGUIKey(jsonKey: "configuration", guiKey: "Configuration")
            static let strokeCycle = JsonOrGUIKey(jsonKey: "stroke_cycle", guiKey: "Stroke cycle")
            static let bore = JsonOrGUIKey(jsonKey: "bore", guiKey: "Bore")
            static let stroke = JsonOrGUIKey(jsonKey: "stroke", guiKey: "Stroke")
            static let displacement = JsonOrGUIKey(jsonKey: "displacement", guiKey: "Displacement")
            static let compression = JsonOrGUIKey(jsonKey: "compression", guiKey: "Compression ratio")
            let power: Power
            static let feedSystem = JsonOrGUIKey(jsonKey: "feed_system", guiKey: "Feed system")
            
            struct Power {
                static let jsonKey = "power"
                static let guiKey = "Power"
                
                static let peak = JsonOrGUIKey(jsonKey: "peak", guiKey: "")
                static let rpm = JsonOrGUIKey(jsonKey: "rpm", guiKey: "")
            }
        }
        
        struct Frame {
            static let jsonKey = "frame"
            static let guiKey = "Frame And Brakes"
            
            static let type = JsonOrGUIKey(jsonKey: "type", guiKey: "Type")
            static let frontSuspension = JsonOrGUIKey(jsonKey: "front_suspension", guiKey: "Front suspension")
            static let rearSuspension = JsonOrGUIKey(jsonKey: "rear_suspension", guiKey: "Rear suspension")
            static let wheelbase = JsonOrGUIKey(jsonKey: "wheelbase", guiKey: "Wheelbase")
            static let brakes = JsonOrGUIKey(jsonKey: "brakes", guiKey: "Brakes")
        }
        
        struct CapacitiesAndPerformance {
            static let jsonKey = "capacities_performances"
            static let guiKey = "Capacities And Performances"
            
            static let fuelCapacity = JsonOrGUIKey(jsonKey: "fuel_capacity", guiKey: "Fuel capacity")
            static let lubricantCapacity = JsonOrGUIKey(jsonKey: "lubricant_capacity", guiKey: "Lubricant capacity")
            static let weight = JsonOrGUIKey(jsonKey: "weight", guiKey: "Weight")
            static let maxSpeed = JsonOrGUIKey(jsonKey: "max_speed", guiKey: "Maximum speed")
            static let fuelConsumption = JsonOrGUIKey(jsonKey: "fuel_consumption", guiKey: "Fuel consumption")
        }
        
        struct RowNote {
            static let jsonKey = "notes"
            static let guiKey = "Notes"
        }
        
        struct RowImage {
            static let jsonKey = "images"
            static let guiKey = "Images"
        }
    }
    
    struct JsonFile {
        static let version = "version"
        static let totalElements = "total_elements"
        static let elements = "elements"
    }
    
    internal struct JsonOrGUIKey {
        let jsonKey: String
        let guiKey: String
    }
}
