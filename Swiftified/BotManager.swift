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
    @Published private var managerrr = LocationKeepAlive.shared
    #endif
    
    private init() {}
    
    func startBot() {
        logger.info("Called bot start")
        DispatchQueue.global(qos: .background).async {
            let newBot = Bot()
            #if os(iOS)
            self.managerrr.start()
            #endif
            newBot.start()
            DispatchQueue.main.async {
                self.bot = newBot
            }
        }
    }

    func stopBot() {
        logger.info("Called bot stop")
        #if os(iOS)
        self.managerrr.stop()
        #endif
        bot?.sybau()
        bot = nil
    }
    
    func reboot() {
        logger.info("Rebooting bot")
        stopBot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startBot()
        }
    }
}

