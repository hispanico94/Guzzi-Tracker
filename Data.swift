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
