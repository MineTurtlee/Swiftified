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
    @AppStorage("token") public var token: String = ""
    @AppStorage("statusMode") private var selection: String = "Nothing"
    @AppStorage("statuss") private var status = "Online"
    @AppStorage("statusName") public var statusName: String = ""
    @AppStorage("prefix") public var prefix: String = "!"
    @AppStorage("tokenType") var tokenType: String = "Bot"
    lazy var slashHandler = SlashCommands(cliente)
    private var statusMode: DiscordActivityType? = nil
    public var cliente: DiscordClient!
    private var statuspid: DiscordPresenceStatus = .online
    var tokentype: String = ""
    
    func getTokenType(from selection: String) {
        switch selection {
        case "User": tokentype = ""
        case "Bot": tokentype = "Bot "
        default: tokentype = "Bot "
        }
    }
    
    func updateStatus(from selection: String) {
        switch selection {
        case "Online":            statuspid = DiscordPresenceStatus.online
        case "Idle", "Away":      statuspid = DiscordPresenceStatus.idle
        case "Do Not Disturb":    statuspid = DiscordPresenceStatus.doNotDisturb
        case "Offline":           statuspid = DiscordPresenceStatus.offline
        default:                  statuspid = DiscordPresenceStatus.online
        }
    }
    
    func updateStatusMode(from selection: String) {
        switch selection {
        case "Playing":
            statusMode = .game
        case "Streaming":
            statusMode = .stream
        case "Listening":
            statusMode = .listening
        case "Watching":
            statusMode = .watching
        default:
            statusMode = nil
        }
    }
    
    func start() {
        getTokenType(from: tokenType)
        cliente = DiscordClient(
            token: "\(tokentype)\(token)",
            delegate: self,
            configuration: [
                .intents([.allIntents])
            ]
        )
        cliente.connect()
        wow(cliente)
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
    
    func publishPresence() {
        updateStatusMode(from: selection)
        updateStatus(from: status)
        let newPresence = DiscordPresenceUpdate(
            activities: [
                DiscordActivity(name: statusName, type: statusMode ?? .game),
                DiscordActivity(name: "Practicing Swift", type: .game)
            ],
            status: statuspid,
            afkSince: nil
        )
        cliente.setPresence(newPresence)
        
    }
   
    func wow(_ client: DiscordClient) {
        while client.connected != true {
            Thread.sleep(forTimeInterval: 0.1)
        }
        publishPresence()
        SlashCommands(cliente, initTree: true)
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
    
    #if os(iOS)
    private var reconnectTask: DispatchWorkItem?

    private func attemptReconnect() {
        reconnectTask?.cancel()

        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            logger.info("Attempting reconnect...")
            self.cliente.connect()
        }

        reconnectTask = task
        DispatchQueue.global().asyncAfter(deadline: .now() + 5, execute: task)
    }
    
    func client(_ client: DiscordClient, didDisconnectWithReason reason: String?) {
        logger.warning("Disconnected: \(reason ?? "no reason")")
        attemptReconnect()
    }
    #endif
}
