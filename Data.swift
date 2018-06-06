//
//  Data.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 01/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import Foundation
import Argo

/// Creates and returns the motorcycle list from the json in the library directory
/// - returns: An array of Motorcycle, nil if the data acquisition or the parsing fail
func getMotorcycleListFromJson() -> [Motorcycle]? {
    let libraryUrls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
    
    guard
        let infoMotoJsonUrl = libraryUrls.first?.appendingPathComponent("info_moto.json"),
        let jsonData = try? Data(contentsOf: infoMotoJsonUrl),
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    else { return nil }
    
    let file: Decoded<JsonFile> = decode(json)
    var decodedMoto: [Motorcycle]
    
    switch file {
    case .success(let decodedFile):
        decodedMoto = decodedFile.elements
    case .failure(let error):
        print("\(error)")
        return nil
    }
    return decodedMoto
}

/// Save the bundle's info_moto.json in the library directory if it doesn't already exists.
func saveMotorcycleJsonToLibrary() {
    let libraryUrls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
    let infoMotoJsonUrl = libraryUrls.first!.appendingPathComponent("info_moto.json")
    
    let jsonBundleUrl = Bundle.main.url(forResource: "info_moto", withExtension: "json")
    let jsonData = try! Data(contentsOf: jsonBundleUrl!)
    
    if !FileManager().fileExists(atPath: infoMotoJsonUrl.path) {
        try! jsonData.write(to: infoMotoJsonUrl, options: .atomic)
    }
}

extension Array {
    func appending (_ element: Element) -> Array {
        var mutatingSelf = self
        mutatingSelf.append(element)
        return mutatingSelf
    }
}

extension Array where Element: Comparable {
    func removeDuplicates() -> Array {
        return self
            .sorted() { $0 < $1 }
            .reduce([]) { (accumulator, element) in
                if let last = accumulator.last, last == element {
                    return accumulator
                } else {
                    return accumulator.appending(element)
                }
        }
    }
}

func getFoundationYear() -> Int { return 1921 }
func getCurrentYear() -> Int { return Calendar(identifier: .gregorian).component(.year, from: Date()) }

