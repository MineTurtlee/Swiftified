//
//  Bot.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 11/8/25.
//

import Discord
import Dispatch
import Logging
import Foundation

fileprivate let logger = Logger(label: "SwiftifiedBot")

class Bot: @preconcurrency DiscordClientDelegate, @unchecked Sendable {
    // MARK: Initialize variables
    static let shared = Bot()
    var cliente: DiscordClient!
    var prefix: String = ""
    lazy var slashHandler = SlashCommands(cliente)
    
    func start(_ token: String, _ tokenType: String,_ prefix1: String) {
        var tokenType1: String
        switch tokenType {
        case "User": tokenType1 = ""
        case "Bot": tokenType1 = "Bot "
        default: tokenType1 = "Bot "
        }
        cliente = DiscordClient(
            token: "\(tokenType1)\(token)",
            delegate: self,
            configuration: [
                .intents([.allIntents])
            ]
        )
        prefix = prefix1
        cliente.connect()
        wow(cliente)
    }
    
    func wow(_ client: DiscordClient) {
        while client.connected != true {
            Thread.sleep(forTimeInterval: 0.1)
        }
        do {
            try? logger.info("Bot started as \((cliente.user)!.username!) (\((cliente.user)!.id)) • Is Bot: \((cliente.user)!.bot!)")
        }
        catch {
            logger.error("Error while trying to list initial information.")
        }
        if (((cliente.user)!.bot!) == true) {
            let botlink = client.getBotURL(with: DiscordPermissions(590980454018134))
            logger.info("Bot invite: \(botlink!)")
        }
        else {}
    }
    
    func sybau() {
        cliente.disconnect()
    }
    
    @MainActor func client(_ client: DiscordClient, didCreateMessage message: DiscordMessage) {
        let ctx = message.channelId
        let cotnetn = message.content
        if ((cotnetn?.starts(with: prefix)) == true) {
            let command = cotnetn?.replacingOccurrences(of: prefix, with: "")
            PrefixedCommands().invokeCommand(command: command!, client: client, ctx: ctx, message: message, prefix: prefix)
            return
        }
        Responses(client: client, message: message)
    }
    
    @MainActor func client(_ client: DiscordClient, didCreateInteraction interaction: DiscordInteraction) {
        switch interaction.type {
        case .applicationCommand:
            // This is ONLY for `/slash` commands
            slashHandler.invokeCommand(client, interaction: interaction, prefix: prefix)
            
        case .messageComponent:
            // Handle button presses here if you need
            logger.info("Received a button/interaction, not a slash command")
            
        default:
            logger.debug("Unhandled interaction type: \(interaction.type!)")
        }
    }
    
    @MainActor func client(_ client: DiscordClient, didDisconnectWithReason reason: DiscordGatewayCloseReason) {
        // TODO: Actually help the error instead of exits directly
        switch reason {
        case .alreadyAuthenticated: logger.info("Already authenticated, doing nothing")
        case .authenticationFailed, .notAuthenticated: logger.info("Auth failed, exiting"); exit(1)
        case .decodeError: logger.info("Exiting: Bad packet"); exit(1)
        case .disconnected, .normal, .goingAway, .noNetwork, .voiceServerCrash: logger.info("Exiting due to connection errors"); exit(1)
        case .invalidSequence, .invalidShard, .sessionTimeout: logger.info("Exiting: the shard or session expired"); exit(1)
        case .unknown, .unknownEncryptionMode, .unknownError, .unknownOpcode, .unknownOpcode, .unknownProtocol: logger.info("Got unknown error. Exiting"); exit(1)
        default: logger.info("Exiting, unknown error"); exit(1)
        }
    }
}
