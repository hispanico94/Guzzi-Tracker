import UIKit

class VCFactory {
    
    let motorcycleList: [Motorcycle]?
    
    let filterProviders: [FilterProvider]
    
    let filterStorage: Ref<Array<FilterProvider>>
    let orderStorage: Ref<Array<Order>>
    
    
    init(motorcycleList: [Motorcycle]?) {
        
        self.motorcycleList = motorcycleList
        
        self.filterProviders = [MinMaxYear(),
                                Family(motorcycleList: self.motorcycleList),
                                Weight(motorcycleList: self.motorcycleList),
                                Displacement(motorcycleList: self.motorcycleList),
                                Bore(motorcycleList: self.motorcycleList),
                                Stroke(motorcycleList: self.motorcycleList),
                                Power(motorcycleList: self.motorcycleList),
                                Wheelbase(motorcycleList: self.motorcycleList),
                                StrokeCycle()]
        
        self.filterStorage = Ref<Array<FilterProvider>>.init(self.filterProviders)
        
        self.orderStorage = Ref<Array<Order>>.init([Order.init(id: .yearDescending, title: "Year descending", comparator: MotorcycleComparator.yearDescending)])
    }
    
    func makeMotorcyclesVC() -> MotorcyclesViewController {
        let motorcyclesVC = MotorcyclesViewController(motorcycleList: motorcycleList, vcFactory: self)
        motorcyclesVC.title = "Motorcycles"
        motorcyclesVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter_icon"), style: .plain, target: nil, action: nil)
        motorcyclesVC.tabBarItem = UITabBarItem(title: "Motorcycles", image: UIImage(named: "motorcycle_regular_tab_icon"), tag: 0)
        return motorcyclesVC
    }
    
    func makeSearchVC() -> SearchViewController {
        let searchVC = SearchViewController(motorcycleList: motorcycleList)
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        return searchVC
    }
    
    func makeMyGarageVC() -> MyGarageViewController {
        let myGarageVC = MyGarageViewController(motorcycleList: motorcycleList)
        myGarageVC.title = "My Garage"
        myGarageVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_icon"), style: .plain, target: nil, action: nil)
        myGarageVC.tabBarItem = UITabBarItem(title: "My Garage", image: UIImage(named: "my_garage_regular_tab_icon"), tag: 2)
        return myGarageVC
    }
    
    func makeFiltersVC(motorcyclesDisplayed: Ref<Int>) -> FiltersViewController {
        let filterVC = FiltersViewController(filterProviders: filterProviders, filterStorage: filterStorage, orderStorage: orderStorage, motorcyclesDisplayed: motorcyclesDisplayed)
        filterVC.title = "Filter & Order"
        return filterVC
    }
}
