import UIKit

class VCFactory {
    
    let motorcycleData: MotorcycleData
    
    init(motorcycleData: MotorcycleData) {
        self.motorcycleData = motorcycleData
    }
    
    func makeFirstTabVC() -> MotorcycleSplitViewController {
        let motorcycleSVC = MotorcycleSplitViewController(master: makeMotorcyclesVC())
        
        motorcycleSVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "motorcycle_regular_tab_icon"), tag: 0)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            motorcycleSVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        return motorcycleSVC
    }
    
    func makeSecondTabVC() -> UINavigationController {
        let garageVC = UINavigationController(rootViewController: makeMyGarageVC())
        garageVC.navigationBar.prefersLargeTitles = true
        return garageVC
    }
    
    func makeFiltersVC(motorcyclesDisplayed: Ref<Int>) -> FiltersViewController {
        let filterVC = FiltersViewController(motorcycleData: motorcycleData, motorcyclesDisplayed: motorcyclesDisplayed)
        filterVC.title = NSLocalizedString("Filter & Sort", comment: "'Filter & Sort' (or only 'Filter' if the translated string is longer)")
        return filterVC
    }
    
    func makeInfoVC() -> InfoViewController {
        let infoVC = InfoViewController()
        infoVC.title = NSLocalizedString("About", comment: "title of the view that contains informations about the app and contacts")
        infoVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: infoVC, action: #selector(infoVC.didTapDoneButton(sender:)))
        return infoVC
    }
    
    private func makeMotorcyclesVC() -> MotorcyclesViewController {
        let motorcyclesString = NSLocalizedString("Motorcycles", comment: "Motorcycles")
        let motorcyclesVC = MotorcyclesViewController(vcFactory: self)
        motorcyclesVC.title = motorcyclesString
        motorcyclesVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter_icon"), style: .plain, target: nil, action: nil)
        return motorcyclesVC
    }
    
    private func makeMyGarageVC() -> MyGarageViewController {
        let myGarageString = NSLocalizedString("Garage", comment: "contains a list of favorite motorcycles" )
        let myGarageVC = MyGarageViewController(vcFactory: self)
        myGarageVC.title = myGarageString
        myGarageVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "info_icon"), style: .plain, target: myGarageVC, action: #selector(myGarageVC.didTapInfoButton(sender:)))
        myGarageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "my_garage_regular_tab_icon"), tag: 2)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            myGarageVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        return myGarageVC
    }
}
