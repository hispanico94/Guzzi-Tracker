import Foundation

struct Key {
    
    struct Motorcycle {
        static let id = JsonOrGUIKey(jsonKey: "id", guiKey: "")
        static let notes = JsonOrGUIKey(jsonKey: "notes", guiKey: NSLocalizedString("Notes", comment: "Notes"))
        static let images = JsonOrGUIKey(jsonKey: "images", guiKey: NSLocalizedString("Images", comment: "Images"))
        
        
        struct GeneralInfo {
            static let jsonKey = "general_info"
            static let guiKey = NSLocalizedString("General Info", comment: "General Info")
            
            static let family = JsonOrGUIKey(jsonKey: "family", guiKey: NSLocalizedString("Family", comment: "Family"))
            static let name = JsonOrGUIKey(jsonKey: "name", guiKey: NSLocalizedString("Name", comment: "Name"))
            static let firstYear = JsonOrGUIKey(jsonKey: "first_year", guiKey: NSLocalizedString("Introduced", comment: "Introduced"))
            static let lastYear = JsonOrGUIKey(jsonKey: "last_year", guiKey: NSLocalizedString("Discontinued", comment: "Discontinued"))
        }
        
        struct Engine {
            static let jsonKey = "engine"
            static let guiKey = NSLocalizedString("Engine", comment: "Engine")
            
            static let configuration = JsonOrGUIKey(jsonKey: "engine_configuration", guiKey: NSLocalizedString("Configuration", comment: "Engine Configuration"))
            static let strokeCycle = JsonOrGUIKey(jsonKey: "stroke_cycle", guiKey: NSLocalizedString("Stroke cycle", comment: "Engine Stroke cycle"))
            static let bore = JsonOrGUIKey(jsonKey: "bore", guiKey: NSLocalizedString("Bore", comment: "Engine Bore"))
            static let stroke = JsonOrGUIKey(jsonKey: "stroke", guiKey: NSLocalizedString("Stroke", comment: "Engine Stroke"))
            static let compression = JsonOrGUIKey(jsonKey: "compression", guiKey: NSLocalizedString("Compression ratio", comment: "Compression ratio"))
            static let feed = JsonOrGUIKey(jsonKey: "engine_feed", guiKey: NSLocalizedString("Feed", comment: "Engine Feed"))
            static let ignition = JsonOrGUIKey(jsonKey: "engine_ignition", guiKey: NSLocalizedString("Ignition", comment: "Engine Ignition"))
            
            struct Displacement {
                static let jsonKey = "displacement"
                static let guiKey = NSLocalizedString("Displacement", comment: "Engine Displacement")
                
                static let real = JsonOrGUIKey(jsonKey: "real", guiKey: NSLocalizedString("Real", comment: "Real Displacement"))
                static let nominal = JsonOrGUIKey(jsonKey: "nominal", guiKey: NSLocalizedString("Nominal", comment: "Nominal Displacement"))
            }
            
            struct Power {
                static let jsonKey = "power"
                static let guiKey = NSLocalizedString("Power", comment: "Engine Power")
                
                static let peak = JsonOrGUIKey(jsonKey: "peak", guiKey: "")
                static let rpm = JsonOrGUIKey(jsonKey: "rpm", guiKey: "")
            }
        }
        
        struct Transmission {
            static let jsonKey = "transmission"
            static let guiKey = NSLocalizedString("Transmission", comment: "Transmission")
            
            static let gearbox = JsonOrGUIKey(jsonKey: "transmission_gearbox", guiKey: NSLocalizedString("Gearbox", comment: "Gearbox"))
            static let clutch = JsonOrGUIKey(jsonKey: "transmission_clutch", guiKey: NSLocalizedString("Clutch", comment: "Clutch"))
            static let finalDrive = JsonOrGUIKey(jsonKey: "transmission_final_drive", guiKey: NSLocalizedString("Final drive", comment: "Final drive"))
        }
        
        struct Frame {
            static let jsonKey = "frame"
            static let guiKey = NSLocalizedString("Frame", comment: "Frame")
            
            static let type = JsonOrGUIKey(jsonKey: "frame_type", guiKey: NSLocalizedString("Type", comment: "Type"))
            static let frontSuspension = JsonOrGUIKey(jsonKey: "frame_front_suspension", guiKey: NSLocalizedString("Front suspension", comment: "Front suspension"))
            static let rearSuspension = JsonOrGUIKey(jsonKey: "frame_rear_suspension", guiKey: NSLocalizedString("Rear suspension", comment: "Rear suspension"))
            static let wheelbase = JsonOrGUIKey(jsonKey: "wheelbase", guiKey: NSLocalizedString("Wheelbase", comment: "Wheelbase"))
            static let wheels = JsonOrGUIKey(jsonKey: "wheels", guiKey: NSLocalizedString("Wheels", comment: "Wheels"))
            static let tyres = JsonOrGUIKey(jsonKey: "tyres", guiKey: NSLocalizedString("Tyres", comment: "Tyres"))
        }
        
        struct Brakes {
            static let jsonKey = "brakes"
            static let guiKey = NSLocalizedString("Brakes", comment: "Brakes")
            
            static let type = JsonOrGUIKey(jsonKey: "brakes_type", guiKey: NSLocalizedString("Type", comment: "Type"))
            static let frontSize = JsonOrGUIKey(jsonKey: "front_size", guiKey: NSLocalizedString("Front size", comment: "Front size (Brakes)"))
            static let rearSize = JsonOrGUIKey(jsonKey: "rear_size", guiKey: NSLocalizedString("Rear size", comment: "Rear size (Brakes)"))
            static let notes = JsonOrGUIKey(jsonKey: "brakes_notes", guiKey: NSLocalizedString("Notes", comment: "Notes"))
        }
        
        struct CapacitiesAndPerformance {
            static let jsonKey = "capacities_performances"
            static let guiKey = NSLocalizedString("Capacities and Performance", comment: "Capacities and Performance")
            
            static let fuelCapacity = JsonOrGUIKey(jsonKey: "fuel_capacity", guiKey: NSLocalizedString("Fuel tank", comment: "Fuel tank"))
            static let lubricantCapacity = JsonOrGUIKey(jsonKey: "lubricant_capacity", guiKey: NSLocalizedString("Engine oil", comment: "Engine oil"))
            static let weight = JsonOrGUIKey(jsonKey: "weight", guiKey: NSLocalizedString("Weight", comment: "Weight"))
            static let maxSpeed = JsonOrGUIKey(jsonKey: "max_speed", guiKey: NSLocalizedString("Max speed", comment: "Maximum speed"))
            static let fuelConsumption = JsonOrGUIKey(jsonKey: "fuel_consumption", guiKey: NSLocalizedString("Fuel consumption", comment: "Fuel consumption"))
        }
        
        struct RowNote {
            static let jsonKey = "notes"
            static let guiKey = NSLocalizedString("Notes", comment: "Notes")
        }
        
        struct RowImage {
            static let jsonKey = "images"
            static let guiKey = NSLocalizedString("Images", comment: "Images")
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
