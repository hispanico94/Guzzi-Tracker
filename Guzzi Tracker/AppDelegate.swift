import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let motorcycleList = getMotorcycleListFromJson()
    
    lazy var vcFactory: VCFactory = VCFactory.init(motorcycleList: motorcycleList)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
// UIColor(displayP3Red: 54.0/255.0, green: 103.0/255.0, blue: 53.0/255.0, alpha: 1.0) RAL 6001 (colore simile a quello dell'8 cilindri)
// UIColor(displayP3Red: 181.0/255.0, green: 208.0/255.0, blue: 81.0/255.0, alpha: 1.0) Verde Legnano da Wikipedia
// UIColor(displayP3Red: 195.0/255.0, green: 21.0/255.0, blue: 26.0/255.0, alpha: 1.0) Rosso V7 Sport telaio rosso
        
//        UINavigationBar.appearance().tintColor = UIColor(displayP3Red: 54.0/255.0, green: 103.0/255.0, blue: 53.0/255.0, alpha: 1.0)
//        UITabBar.appearance().tintColor = UIColor(displayP3Red: 54.0/255.0, green: 103.0/255.0, blue: 53.0/255.0, alpha: 1.0)
//        UISearchBar.appearance().tintColor = UIColor(displayP3Red: 54.0/255.0, green: 103.0/255.0, blue: 53.0/255.0, alpha: 1.0)
//        UITableView.appearance().tintColor = UIColor(displayP3Red: 54.0/255.0, green: 103.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        
        UIApplication.shared.delegate?.window??.tintColor = UIColor.guzziRed
        UINavigationBar.appearance().barTintColor = UIColor.legnanoGreen
        UITabBar.appearance().barTintColor = UIColor.legnanoGreen
        UIToolbar.appearance().barTintColor = UIColor.legnanoGreen
        
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

