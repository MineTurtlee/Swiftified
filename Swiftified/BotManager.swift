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

    func startBot() {
        logger.info("Called bot start")
        DispatchQueue.global(qos: .background).async {
            let newBot = Bot()
            newBot.start()
            DispatchQueue.main.async {
                self.bot = newBot
            }
        }
    }

    func stopBot() {
        logger.info("Called bot stop")
        bot?.sybau()
        bot = nil
    }
}

