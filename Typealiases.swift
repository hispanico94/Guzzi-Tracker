
// TO BE ERASED
//typealias MotorcycleComparator = (Motorcycle, Motorcycle) -> Bool
//
//// TEST
//var nameAscending: MotorcycleComparator = { moto1, moto2 in
//    return moto1.generalInfo.name < moto2.generalInfo.name
//}
//
//var compressionAscending: MotorcycleComparator = { moto1, moto2 in
//    return moto1.engine.compression < moto2.engine.compression
//}


typealias Comparator<A> = Function<(A, A), Ordering>
