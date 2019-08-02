import Foundation

// MARK: - Texts definition

/// Texts represents the motorcycles localized texts under the `texts` key in the info_moto.json JSON file.
/// In particular, the correct representation of the data under `texts` is `[String: Texts]` where the keys of
/// the dictionary are the id of the motorcycles and the value are the localized texts for the motorcycle with that
/// particular id. Only the texts with the appropriate language are parsed, the language depends on the Locale of the device;
/// if the language set on the device is italian the texts parsed will be italian, otherwise the english texts will be parsed
/// (this will change if new languages are added).
struct Texts: Decodable {
    let engine_configuration: Language
    let engine_feed: Language
    let engine_ignition: Language
    
    let transmission_gearbox: Language
    let transmission_clutch: Language
    let transmission_final_drive: Language
    
    let frame_type: Language
    let frame_front_suspension: Language
    let frame_rear_suspension: Language
    
    let brakes_type: Language
    let brakes_notes: Language
    
    let notes: Language
    
    struct Language: Decodable {
        private let it: String?
        private let en: String?
        
        private var isItalian: Bool {
            guard let languageCode = Calendar.current.locale?.languageCode else { return false }
            return languageCode == "it" ? true : false
        }
        
        var string: String? {
            return isItalian ? it : en
        }
    }
}
