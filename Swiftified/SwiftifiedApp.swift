//
//  SwiftifiedApp.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

@main
struct SwiftifiedApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


/*
 //
 //  SwiftifiedApp.swift
 //  Swiftified
 //

 import SwiftUI
 import Discord
 import CoreLocation
 import Logging

 @main
 struct SwiftifiedApp: App {
     
     // Keep these singletons alive for the app's lifetime
     @StateObject private var bot = Bot.shared
     @StateObject private var locationManager = LocationKeepAlive.shared

     init() {
         // Start bot and location services immediately on launch
         bot.start()
         locationManager.start()
     }

     var body: some Scene {
         WindowGroup {
             ContentView()
                 .onAppear {
                     // Ensure permissions are requested
                     locationManager.requestPermission()
                 }
         }
     }
 }

 */
