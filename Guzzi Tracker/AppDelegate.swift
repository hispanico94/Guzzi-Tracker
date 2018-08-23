import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var vcFactory: VCFactory?
    var motorcycleData: MotorcycleData?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // Appearance customization
        
        UIApplication.shared.delegate?.window??.tintColor = UIColor.guzziRed
        UINavigationBar.appearance().barTintColor = UIColor.legnanoGreen
        UITabBar.appearance().barTintColor =  UIColor.legnanoGreen
        UIToolbar.appearance().barTintColor = UIColor.legnanoGreen
        
        // Data and vcFactory initialization
        
        motorcycleData = MotorcycleData()
        motorcycleData?.updateJson()
        
        vcFactory = VCFactory(motorcycleData: motorcycleData!)
        
        // View controllers initialization
        
        let firstVC = UINavigationController(rootViewController: vcFactory!.makeMotorcyclesVC())
        let secondVC = UINavigationController(rootViewController: vcFactory!.makeSearchVC())
        let thirdVC = UINavigationController(rootViewController: vcFactory!.makeMyGarageVC())
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstVC, secondVC, thirdVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        motorcycleData?.updateJson()
    }
}

