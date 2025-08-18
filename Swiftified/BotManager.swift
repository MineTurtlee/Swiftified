//
//  BotManager.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 11/8/25.
//

import SwiftUI

class BotManager: ObservableObject {
    private var bot: Bot?

    func startBot() {
        DispatchQueue.global(qos: .background).async {
            let newBot = Bot()
            newBot.start()
            
            DispatchQueue.main.async {
                self.bot = newBot
            }
        }
    }

    func stopBot() {
        bot?.sybau()
        bot = nil
    }
}

