//
//  AppDelegate.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 30/8/25.
//

#if os(iOS)
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Ask iOS to wake the app as often as possible
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        return true
    }
    
    // Background fetch entry point
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BotManager.shared.startBot()
        completionHandler(.newData)
    }
}
#endif
