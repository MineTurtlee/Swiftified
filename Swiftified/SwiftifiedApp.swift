//
//  SwiftifiedApp.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

@main
struct SwiftifiedApp: App {
    @ObservedObject var manager = BotManager.shared
    @ObservedObject var tmp = TempVars.shared
    @AppStorage("autoStart") var autoStart: Bool = false
    @State var showPopup = false
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    showPopup = true
                }
                .alert(isPresented: $showPopup) {
                    let alr = Alert(
                        title: Text("Bot Auto Started"),
                        message: Text("Configure auto start behavior by heading into Settings page!"),
                        dismissButton: .default(Text("Okie dokie!"), action: {
                            tmp.hasStarted = true
                            manager.startBot()
                        })
                    )
                    return alr
                }
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
