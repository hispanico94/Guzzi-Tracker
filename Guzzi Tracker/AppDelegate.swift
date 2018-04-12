import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let motorcycleList = getMotorcycleListFromJson()
    
    lazy var filterStorage = Ref<Array<FilterProvider>>.init([MinMaxYear(), Family(motorcycleList: self.motorcycleList), Weight(motorcycleList: self.motorcycleList)])
    lazy var vcFactory: VCFactory = VCFactory.init(motorcycleList: motorcycleList, filterStorage: self.filterStorage)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let firstVC = UINavigationController(rootViewController: vcFactory.makeMotorcyclesVC())
        let secondVC = UINavigationController(rootViewController: vcFactory.makeSearchVC())
        let thirdVC = UINavigationController(rootViewController: vcFactory.makeMyGarageVC())
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstVC, secondVC, thirdVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}

