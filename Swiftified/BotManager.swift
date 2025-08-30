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
    private var bot: Bot?
    @ObservedObject private var tmp = TempVars.shared
    #if os(iOS)
        private var managerrr = LocationKeepAlive()
    #endif
    
    func startBot() {
        logger.info("Called bot start")
        DispatchQueue.global(qos: .background).async {
            let newBot = Bot()
            newBot.start()
            DispatchQueue.main.async {
                self.bot = newBot
                #if os(iOS)
                self.managerrr.start()
                #endif
            }
        }
    }

    func stopBot() {
        logger.info("Called bot stop")
        bot?.sybau()
        bot = nil
        #if os(iOS)
            self.managerrr.stop()
        #endif
    }
}

