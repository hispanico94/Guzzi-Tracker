import UIKit

class VCFactory {
    
    let filterStorage: Ref<Array<FilterProvider>>
    let motorcycleList: [Motorcycle]?
    
    
    init(motorcycleList: [Motorcycle]?, filterStorage: Ref<Array<FilterProvider>>) {
        self.motorcycleList = motorcycleList
        self.filterStorage = filterStorage
    }
    
    func makeMotorcyclesVC() -> MotorcyclesViewController {
        let motorcyclesVC = MotorcyclesViewController(motorcycleList: motorcycleList, filterStorage: filterStorage, vcFactory: self)
        motorcyclesVC.title = "Motorcycles"
        motorcyclesVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter_icon"), style: .plain, target: nil, action: nil)
        motorcyclesVC.tabBarItem = UITabBarItem(title: "Motorcycles", image: UIImage(named: "motorycles_tab_icon"), tag: 0)
        return motorcyclesVC
    }
    
    func makeSearchVC() -> SearchViewController {
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        return searchVC
    }
    
    func makeMyGarageVC() -> MyGarageViewController {
        let myGarageVC = MyGarageViewController(nibName: "MyGarageViewController", bundle: nil)
        myGarageVC.title = "My Garage"
        myGarageVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_icon"), style: .plain, target: nil, action: nil)
        myGarageVC.tabBarItem = UITabBarItem(title: "My Garage", image: UIImage(named: "my_garage_tab_icon"), tag: 2)
        return myGarageVC
    }
    
    func makeFiltersVC() -> FiltersViewController {
        let filterVC = FiltersViewController(filterStorage: filterStorage)
        filterVC.title = "Filter & Order"
        return filterVC
    }
}
