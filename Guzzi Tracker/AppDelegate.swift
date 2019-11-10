import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var vcFactory: VCFactory?
    var motorcycleData: MotorcycleData?
    
    let review = Review.sharedReview
    
    var userInterfaceStyleChangeObserver: NSKeyValueObservation!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Launch counter update
        
        review.incrementCounter()

        // Appearance customization
        
        customizeAppearance()
        
        // Data and vcFactory initialization
        
        motorcycleData = MotorcycleData()
        motorcycleData?.updateJson()
        
        vcFactory = VCFactory(motorcycleData: motorcycleData!)
        
        // View controllers initialization
        let motorcyclesVC = vcFactory!.makeFirstTabVC()
        
        let garageVC = vcFactory!.makeSecondTabVC()
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [motorcyclesVC, garageVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        review.saveActiveDate()
        
        motorcycleData?.updateJson()
    }
    
    
    private func customizeAppearance() {
        if #available(iOS 13.0, *) {
            setupNewAppearance()
        } else {
            setupOldAppearance()
        }
    }
    
    private func setupOldAppearance() {
        UIApplication.shared.delegate?.window??.tintColor = UIColor.guzziRed
    }
    
    @available(iOS 13.0, *)
    private func setupNewAppearance() {
        let barButtonAppearance = UIBarButtonItemAppearance()
        barButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "accent")!]
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backButtonAppearance = barButtonAppearance
        navBarAppearance.buttonAppearance = barButtonAppearance
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = UIColor(named: "accent")!
        
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.selected.iconColor = UIColor(named: "accent")!
        tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "accent")!]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
}

