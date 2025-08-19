//
//  Bot.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 11/8/25.
//

import Discord
import Dispatch
import SwiftUI

class Bot: DiscordClientDelegate {
    
    // MARK: Initialize variables
    
    @AppStorage("token") public var token: String = ""
    @AppStorage("statusMode") private var selection: String = "Nothing"
    @AppStorage("statuss") private var status = "Online"
    @AppStorage("statusName") public var statusName: String = ""
    @AppStorage("prefix") public var prefix: String = "!"
    private var statusMode: DiscordActivityType? = nil
    
    private var statuspid: DiscordPresenceStatus = .online
    
    // MARK: These won't work
    
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
    
    // MARK: Things work from here
    
    private var client: DiscordClient!
    
    func start() {
        client = DiscordClient(
            token: "Bot \(token)",
            delegate: self,
            configuration: [
                .intents([.allIntents])
            ]
        )
        client.connect()
        wow(client)
    }
    
    func sybau() {
        client.disconnect()
    }
    
    func publishPresence() {
        let newPresence = DiscordPresenceUpdate(
            activities: [
                DiscordActivity(name: statusName, type: statusMode ?? .game),
                DiscordActivity(name: "Practicing Swift", type: .game)
            ],
            status: statuspid,
            afkSince: nil
        )
        client.setPresence(newPresence)
        updateStatusMode(from: selection)
        updateStatus(from: status)
    }
   
    func wow(_ client: DiscordClient) {
        while client.connected != true {
            Thread.sleep(forTimeInterval: 0.1)
        }
        publishPresence()
    }
    
    func client(_ client: DiscordClient, didCreateMessage message: DiscordMessage) {
        let ctx = message.channelId
        let cotnetn = message.content
        if ((cotnetn?.starts(with: "sw!")) != nil) {
            let command = cotnetn?.replacingOccurrences(of: "sw!", with: "")
            Commands.PrefixedCommands().invokeCommand(command: command!, client: client, ctx: ctx, message: message)
        }
        if let content = message.content {
            let pattern = #"(?i)\bkms\b|\bk(i|!|1|¡|l)(1|l|i|!|¡)(1|l|i|!|¡) my(s|5)(e|3)+"#
            if content.range(of: pattern, options: .regularExpression) != nil {
                client.sendMessage("Click into the image and read both the text, big and small.", to: message.channelId)
                client.sendMessage("https://cdn.discordapp.com/attachments/1024941835891785771/1385086676296269895/IMG_3110.jpg?ex=689aa97d&is=689957fd&hm=d2ce5b01edb07ab92002f8cacdb155c9fb30ab6346177160c991126d38011ffb&", to: ctx)
            }
        }
    }
}
