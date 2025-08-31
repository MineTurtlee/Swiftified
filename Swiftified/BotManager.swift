//
//  BotManager.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 11/8/25.
//

import SwiftUI
import Logging

fileprivate var logger = Logger(label: "SwiftifiedBotManager")

class BotManager: ObservableObject {
    static let shared = BotManager()
    private var bot: Bot?
    @ObservedObject private var tmp = TempVars.shared
    #if os(iOS)
    @ObservedObject private var located = LocationKeepAlive.shared
    #endif
    
    private init() {}
    
    func startBot() {
        logger.info("Called bot start")
        DispatchQueue.global(qos: .background).async {
            let newBot = Bot()
            newBot.start()
            self.tmp.hasStarted = true
            DispatchQueue.main.async {
                #if os(iOS)
                self.located.start()
                #endif
                self.bot = newBot
            }
        }
    }

    func stopBot() {
        logger.info("Called bot stop")
        #if os(iOS)
        self.located.stop()
        #endif
        bot?.sybau()
        bot = nil
        self.tmp.hasStarted = false
    }
    
    func reboot() {
        logger.info("Rebooting bot")
        stopBot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startBot()
        }
    }
}

