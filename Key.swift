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
            
            static let configuration = JsonOrGUIKey(jsonKey: "engine_configuration", guiKey: "Configuration")
            static let strokeCycle = JsonOrGUIKey(jsonKey: "stroke_cycle", guiKey: "Stroke cycle")
            static let bore = JsonOrGUIKey(jsonKey: "bore", guiKey: "Bore")
            static let stroke = JsonOrGUIKey(jsonKey: "stroke", guiKey: "Stroke")
            static let compression = JsonOrGUIKey(jsonKey: "compression", guiKey: "Compression ratio")
            static let feed = JsonOrGUIKey(jsonKey: "engine_feed", guiKey: "Feed")
            static let ignition = JsonOrGUIKey(jsonKey: "engine_ignition", guiKey: "Ignition")
            
            struct Displacement {
                static let jsonKey = "displacement"
                static let guiKey = "Displacement"
                
                static let real = JsonOrGUIKey(jsonKey: "real", guiKey: "Real")
                static let nominal = JsonOrGUIKey(jsonKey: "nominal", guiKey: "Nominal")
            }
            
            struct Power {
                static let jsonKey = "power"
                static let guiKey = "Power"
                
                static let peak = JsonOrGUIKey(jsonKey: "peak", guiKey: "")
                static let rpm = JsonOrGUIKey(jsonKey: "rpm", guiKey: "")
            }
        }
        
        struct Transmission {
            static let jsonKey = "transmission"
            static let guiKey = "Transmission"
            
            static let gearbox = JsonOrGUIKey(jsonKey: "transmission_gearbox", guiKey: "Gearbox")
            static let clutch = JsonOrGUIKey(jsonKey: "transmission_clutch", guiKey: "Clutch")
            static let finalDrive = JsonOrGUIKey(jsonKey: "transmission_final_drive", guiKey: "Final drive")
        }
        
        struct Frame {
            static let jsonKey = "frame"
            static let guiKey = "Frame"
            
            static let type = JsonOrGUIKey(jsonKey: "frame_type", guiKey: "Type")
            static let frontSuspension = JsonOrGUIKey(jsonKey: "frame_front_suspension", guiKey: "Front suspension")
            static let rearSuspension = JsonOrGUIKey(jsonKey: "frame_rear_suspension", guiKey: "Rear suspension")
            static let wheelbase = JsonOrGUIKey(jsonKey: "wheelbase", guiKey: "Wheelbase")
            static let wheels = JsonOrGUIKey(jsonKey: "wheels", guiKey: "Wheels")
            static let tyres = JsonOrGUIKey(jsonKey: "tyres", guiKey: "Tyres")
        }
        
        struct Brakes {
            static let jsonKey = "brakes"
            static let guiKey = "Brakes"
            
            static let type = JsonOrGUIKey(jsonKey: "brakes_type", guiKey: "Type")
            static let frontSize = JsonOrGUIKey(jsonKey: "front_size", guiKey: "Front size")
            static let rearSize = JsonOrGUIKey(jsonKey: "rear_size", guiKey: "Rear size")
            static let notes = JsonOrGUIKey(jsonKey: "brakes_notes", guiKey: "Notes")
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
        static let elements = "elements"
        static let texts = "texts"
    }
    
    internal struct JsonOrGUIKey {
        let jsonKey: String
        let guiKey: String
    }
}
