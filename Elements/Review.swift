import Foundation
import StoreKit

/// This class handles the automatic review request to the user. This class is represented by a singleton
/// `sharedReview`. Every interaction with this class is via the singleton. The prompt is handled by
/// `SKStoreReviewController.requestReview()`. The first prompt is displayed after the first
/// ten launches of the app, the second five launches later and the third after another five launces
/// of the app. Prompts are also spaced in time by 24 hours (so that users that fully open and close and app
/// consecutively does not get the prompt), this is also necessary because jumping from a tab to another after
/// a prompt is displayed may cause the prompt to show up again.In any case SKStoreReviewController
/// automatically limits the number of prompts to three every 365 days.
/// This class resets the counter after every update of the app (checks the bundle's version).
/// The prompt is displayed, if possible, 30 seconds after the app become active.
final class Review {
    static let sharedReview = Review()
    
    private let firstRequestCounterValue = 10
    private let secondRequestCounterVaule = 15
    private let thirdRequestCounterValue = 20
    
    private let minimumSecondsElapsedSinceActive = TimeInterval(30)
    
    private var counter: Int
    private var storedAppVersion: String
    private var lastRequestDate: Date?
    private var activeDate: Date
    
    private init() {
        let defaults = UserDefaults.standard
        
        self.counter = defaults.integer(forKey: "launchCounter")
        
        self.lastRequestDate = defaults.object(forKey: "lastRequestDate") as? Date
        
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else {
            fatalError("Expected to find a bundle version in the info dictionary (class Review)")
        }
        
        if let storedVersion = defaults.string(forKey: "storedAppVersion") {
            self.storedAppVersion = storedVersion
        } else {
            self.storedAppVersion = currentAppVersion
        }
        
        if storedAppVersion != currentAppVersion {
            self.counter = 0
            defaults.set(self.counter, forKey: "launchCounter")
        }
        
        self.activeDate = Date()
    }
    
    /// Increment the launch counter. This function needs to be called
    /// in the AppDelegate's `func application(_: didFinishLaunchingWithOptions:)`
    func incrementCounter() {
        counter += 1
        UserDefaults.standard.set(counter, forKey: "launchCounter")
    }
    
    /// Save the time when the application has become active. This
    /// function needs to be called in the AppDelegate's
    /// `func applicationDidBecomeActive(_:)`
    func saveActiveDate() {
        activeDate = Date()
    }
    
    /// Calls the Review's `requestReview()` if appropriate.
    /// This function needs to be called in the
    /// `func viewDidAppear(_:)` of main view controllers.
    func requestReviewIfPossible() {
        let currentDate = Date()
        
        let timeIntervalSinceBecomeActive = currentDate.timeIntervalSince(activeDate)
        guard timeIntervalSinceBecomeActive > minimumSecondsElapsedSinceActive else { return }
        
        if let lastRequest = lastRequestDate {
            let timeIntervalSinceLastRequest = currentDate.timeIntervalSince(lastRequest)
            let oneDayInSeconds = TimeInterval(60 * 60 * 24)
            guard timeIntervalSinceLastRequest > oneDayInSeconds else { return }
        }
        
        switch counter {
        case firstRequestCounterValue,
             secondRequestCounterVaule,
             thirdRequestCounterValue:
            
            lastRequestDate = currentDate
            UserDefaults.standard.set(currentDate, forKey: "lastRequestDate")
            requestReview()
        default:
            return
        }
    }
    
    /// Calls the `SKStoreReviewController.requestReview()` on the main thread after 1 second of delay.
    private func requestReview() {
        let oneSecondFromNow = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: oneSecondFromNow) {
            SKStoreReviewController.requestReview()
        }
    }
}
