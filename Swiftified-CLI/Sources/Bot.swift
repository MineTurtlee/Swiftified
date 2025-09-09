//
//  Bot.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 11/8/25.
//

import Discord
import Dispatch
import SwiftUI
import Logging

fileprivate let logger = Logger(label: "SwiftifiedBot")

class Bot: DiscordClientDelegate {
    // MARK: Initialize variables
    static let shared = Bot()
    
    func start(_ token: String, _ tokenType: String,_ prefix: String) {
        cliente = DiscordClient(
            token: "\(tokentype)\(token)",
            delegate: self,
            configuration: [
                .intents([.allIntents])
            ]
        )
        cliente.connect()
        let botlink = cliente.getBotURL(with: DiscordPermissions(590980454018134))
        logger.info("Bot started as \((cliente.user)!.username!) (\((cliente.user)!.id)) • Is Bot: \((cliente.user)!.bot!)")
        if (((cliente.user)!.bot!) == true) {
            logger.info("Bot invite: \(botlink!)")
        }
        else {}
    }
    
    func sybau() {
        cliente.disconnect()
    }
    
    func client(_ client: DiscordClient, didCreateMessage message: DiscordMessage) {
        let ctx = message.channelId
        let cotnetn = message.content
        if ((cotnetn?.starts(with: prefix)) == true) {
            let command = cotnetn?.replacingOccurrences(of: prefix, with: "")
            PrefixedCommands().invokeCommand(command: command!, client: client, ctx: ctx, message: message)
            return
        }
        Responses(client: client, message: message)
    }
    
    func client(_ client: DiscordClient, didCreateInteraction interaction: DiscordInteraction) {
        switch interaction.type {
        case .applicationCommand:
            // This is ONLY for `/slash` commands
            slashHandler.invokeCommand(client, interaction: interaction)
            
        case .messageComponent:
            // Handle button presses here if you need
            logger.info("Received a button/interaction, not a slash command")
            
        default:
            logger.debug("Unhandled interaction type: \(interaction.type!)")
        }
    }
}
