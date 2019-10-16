import UIKit

class MotorcycleSplitViewController: UISplitViewController {
    let masterViewController: MotorcyclesViewController
    
    init(master: MotorcyclesViewController) {
        self.masterViewController = master
        super.init(nibName: nil, bundle: nil)
        self.setInitialViewControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible
    }
    
    private func setInitialViewControllers() {
        let detailNavController = UINavigationController(rootViewController: EmptyViewController())
        self.viewControllers = [UINavigationController(rootViewController: masterViewController), detailNavController]
    }
}

extension MotorcycleSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        if vc is EmptyViewController == false {
            vc.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
            vc.navigationItem.leftItemsSupplementBackButton = true
        }
        
        guard splitViewController.isCollapsed == false else { return false }
        
        let navController = UINavigationController(rootViewController: vc)
        
        _ = self.viewControllers.popLast()
        self.viewControllers.append(navController)
        
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        masterViewController.clearsSelectionOnViewWillAppear = true
        
        if let navController = secondaryViewController as? UINavigationController,
            navController.viewControllers.first is EmptyViewController {
            return true
        }
        
        return false
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard let navController = primaryViewController as? UINavigationController else { return nil }
        
        let numberOfControllers = navController.viewControllers.count
        
        guard numberOfControllers > 1 else {
            return UINavigationController(rootViewController: EmptyViewController())
        }
        
        masterViewController.clearsSelectionOnViewWillAppear = false
        
        if navController.viewControllers[1] is UINavigationController == false {
            let stack = navController.viewControllers[1 ..< numberOfControllers]
            navController.popToRootViewController(animated: false)
            let secondaryVC = UINavigationController()
            secondaryVC.viewControllers = Array(stack)
            return secondaryVC
        }
        
        return nil
    }
}
