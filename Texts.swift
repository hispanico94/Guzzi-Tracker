import Foundation
import Argo
import Curry

// MARK: - Texts definition

/// Texts represents the motorcycles localized texts under the `texts` key in the info_moto.json JSON file.
/// In particular, the correct representation of the data under `texts` is `[String: Texts]` where the keys of
/// the dictionary are the id of the motorcycles and the value are the localized texts for the motorcycle with that
/// particular id. Only the texts with the appropriate language are parsed, the language depends on the Locale of the device;
/// if the language set on the device is italian the texts parsed will be italian, otherwise the english texts will be parsed
/// (this will change if new languages are added).
struct Texts {
    let engineConfiguration: String
    let engineFeed: String
    let engineIgnition: String
    
    let transmissionGearbox: String
    let transmissionClutch: String
    let transmissionFinalDrive: String
    
    let frameType: String
    let frameFrontSuspension: String
    let frameRearSuspension: String
    
    let brakesType: String
    let brakesNotes: String?
    
    let notes: String?
}

// MARK; - Conforming to Argo.Decodable protocol

extension Texts: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Texts> {
        var languageCode = "en"
        if let unwrappedLanguageCode = Calendar.current.locale?.languageCode, unwrappedLanguageCode == "it" {
            languageCode = "it"
        }
        
        let engineConfiguration: Decoded<String> = json.get(at: [Key.Motorcycle.Engine.configuration.jsonKey, languageCode])
        let engineFeed: Decoded<String> = json.get(at: [Key.Motorcycle.Engine.feed.jsonKey, languageCode])
        let engineIgnition: Decoded<String> = json.get(at: [Key.Motorcycle.Engine.ignition.jsonKey, languageCode])
        
        let transmissionGearbox: Decoded<String> = json.get(at: [Key.Motorcycle.Transmission.gearbox.jsonKey, languageCode])
        let transmissionClutch: Decoded<String> = json.get(at: [Key.Motorcycle.Transmission.clutch.jsonKey, languageCode])
        let transmissionFinalDrive: Decoded<String> = json.get(at: [Key.Motorcycle.Transmission.finalDrive.jsonKey, languageCode])
        
        let frameType: Decoded<String> = json.get(at: [Key.Motorcycle.Frame.type.jsonKey, languageCode])
        let frameFrontSuspension: Decoded<String> = json.get(at: [Key.Motorcycle.Frame.frontSuspension.jsonKey, languageCode])
        let frameRearSuspension: Decoded<String> = json.get(at: [Key.Motorcycle.Frame.rearSuspension.jsonKey, languageCode])
        
        let brakesType: Decoded<String> = json.get(at: [Key.Motorcycle.Brakes.type.jsonKey, languageCode])
        let brakesNotes: Decoded<String?> = json.get(at: [Key.Motorcycle.Brakes.notes.jsonKey, languageCode]).orNil()
        
        let notes: Decoded<String?> = json.get(at: [Key.Motorcycle.notes.jsonKey, languageCode]).orNil()
        
        
        return Decoded.pure(curry(Texts.init))
            .call(engineConfiguration)
            .call(engineFeed)
            .call(engineIgnition)
            .call(transmissionGearbox)
            .call(transmissionClutch)
            .call(transmissionFinalDrive)
            .call(frameType)
            .call(frameFrontSuspension)
            .call(frameRearSuspension)
            .call(brakesType)
            .call(brakesNotes)
            .call(notes)
    }
}
