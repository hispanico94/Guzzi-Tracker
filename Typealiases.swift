//
//  typealiases.swift
//  Guzzi Tracker
//
//  Created by Paolo Rocca on 22/03/17.
//  Copyright © 2017 PaoloRocca. All rights reserved.
//

import Foundation

typealias MotorcycleComparator = (Motorcycle, Motorcycle) -> Bool

// TEST
var nameAscending: MotorcycleComparator = { moto1, moto2 in
    return moto1.generalInfo.name < moto2.generalInfo.name
}
