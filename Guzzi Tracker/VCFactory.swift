import UIKit

class VCFactory {
    
    let motorcycleData: MotorcycleData
    
//    let motorcycleList: [Motorcycle]?
//    
//    let filterProviders: [FilterProvider]
//    
//    let filterStorage: Ref<Array<FilterProvider>>
//    let orderStorage: Ref<Array<Order>>
    
    
//    init(motorcycleList: [Motorcycle]?) {
//
//        self.motorcycleList = motorcycleList
//
//        self.filterProviders = [MinMaxYear(),
//                                Family(motorcycleList: self.motorcycleList),
//                                Weight(motorcycleList: self.motorcycleList),
//                                Displacement(motorcycleList: self.motorcycleList),
//                                Bore(motorcycleList: self.motorcycleList),
//                                Stroke(motorcycleList: self.motorcycleList),
//                                Power(motorcycleList: self.motorcycleList),
//                                Wheelbase(motorcycleList: self.motorcycleList),
//                                StrokeCycle()]
//
//        self.filterStorage = Ref<Array<FilterProvider>>.init(self.filterProviders)
//
//        self.orderStorage = Ref<Array<Order>>.init([Order.init(id: .yearDescending, title: "Year descending", comparator: MotorcycleComparator.yearDescending)])
//    }
    
    init(motorcycleData: MotorcycleData) {
        self.motorcycleData = motorcycleData
    }
    
    func makeMotorcyclesVC() -> MotorcyclesViewController {
        let motorcyclesString = NSLocalizedString("Motorcycles", comment: "Motorcycles")
        let motorcyclesVC = MotorcyclesViewController(vcFactory: self)
        motorcyclesVC.title = motorcyclesString
        motorcyclesVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter_icon"), style: .plain, target: nil, action: nil)
        motorcyclesVC.tabBarItem = UITabBarItem(title: motorcyclesString, image: UIImage(named: "motorcycle_regular_tab_icon"), tag: 0)
        return motorcyclesVC
    }
    
    func makeSearchVC() -> SearchViewController {
        let searchVC = SearchViewController(motorcycleStorage: motorcycleData.motorcycleStorage)
        searchVC.title = NSLocalizedString("Search", comment: "Search")
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        return searchVC
    }
    
    func makeMyGarageVC() -> MyGarageViewController {
        let myGarageString = NSLocalizedString("My Garage", comment: "'My Garage' (or only 'Garage' if the translated string is longer)" )
        let myGarageVC = MyGarageViewController(motorcycleStorage: motorcycleData.motorcycleStorage)
        myGarageVC.title = myGarageString
        myGarageVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_icon"), style: .plain, target: nil, action: nil)
        myGarageVC.tabBarItem = UITabBarItem(title: myGarageString, image: UIImage(named: "my_garage_regular_tab_icon"), tag: 2)
        return myGarageVC
    }
    
    func makeFiltersVC(motorcyclesDisplayed: Ref<Int>) -> FiltersViewController {
        let filterVC = FiltersViewController(motorcycleData: motorcycleData, motorcyclesDisplayed: motorcyclesDisplayed)
        filterVC.title = NSLocalizedString("Filter & Sort", comment: "'Filter & Sort' (or only 'Filter' if the translated string is longer)")
        return filterVC
    }
}
