import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var vcFactory: VCFactory?
    var motorcycleData: MotorcycleData?
    
    let review = Review.sharedReview
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Launch counter update
        
        review.incrementCounter()

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
        let firstVC = MotorcycleSplitViewController(master: vcFactory!.makeMotorcyclesVC())
        firstVC.tabBarItem = UITabBarItem(title: NSLocalizedString("Motorcycles", comment: "Motorcycles"), image: UIImage(named: "motorcycle_regular_tab_icon"), tag: 0)
        let secondVC = UINavigationController(rootViewController: vcFactory!.makeSearchVC())
        let thirdVC = UINavigationController(rootViewController: vcFactory!.makeMyGarageVC())
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstVC, secondVC, thirdVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        review.saveActiveDate()
        
        motorcycleData?.updateJson()
    }
}

