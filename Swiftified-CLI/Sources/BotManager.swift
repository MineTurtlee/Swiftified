//
//  BotManager.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 11/8/25.
//

import Foundation
import Logging

fileprivate let logger = Logger(label: "SwiftifiedBotManager")

class BotManager: @unchecked Sendable {
    static let shared = BotManager()
    lazy var token1: String = ""
    lazy var tokenType1: String = ""
    lazy var prefix1: String = ""
    private var bot: Bot?
    
    private init() {}
    
    func startBot(_ token: String,_ tokenType: String,_ prefix: String) {
        logger.info("Called bot start")
        token1 = token
        tokenType1 = tokenType
        prefix1 = prefix
        DispatchQueue.global(qos: .background).async {
            let newBot = Bot()
            newBot.start(token, tokenType, prefix)
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
    
    func reboot() {
        logger.info("Rebooting bot")
        let token = token1
        let tokenType = tokenType1
        let prefix = prefix1
        stopBot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            BotManager.shared.startBot(token, tokenType, prefix)
        }
    }
}

