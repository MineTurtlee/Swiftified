//
//  PrefixedCommands.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 25/8/25.
//
import Foundation
import Discord
import Logging
import SwiftUI

fileprivate let logger = Logger(label: "PrefixedCommands")

class PrefixedCommands {
    @StateObject var manager = BotManager.shared
    @ObservedObject var tmp = TempVars.shared
    @AppStorage("prefix") var prefix: String = ""
    init() {}
    func invokeCommand(command: String, client: DiscordClient, ctx: ChannelID, message: DiscordMessage) {
        let author = message.author
        let components = command.split(separator: " ", omittingEmptySubsequences: true)
        let cmd = String(components.first ?? "")
        let args = components.count > 1 ? String(components[1]) : ""
        
        switch cmd {
        case "help":
            client.sendMessage(DiscordMessage(
                embeds: [
                    DiscordEmbed(
                        title: "Help",
                        description: "Help for the bot",
                        fields: [
                            DiscordEmbed.Field(
                                name: "General",
                                value:
                                    """
                                    - `\(prefix)help`
                                    -# Shows this message.
                                    - `\(prefix)echo <message>`
                                    -# Tapbacks what you say - but with a greetings!
                                    """
                            ),
                            DiscordEmbed.Field(
                                name: "Moderation",
                                value:
                                    """
                                    - `\(prefix)ban <user ping/id>`
                                    -# Bans the passed user (Required: Ban Members)
                                    """
                            ),
                            DiscordEmbed.Field(
                                name: "Owners",
                                value:
                                    """
                                    - `\(prefix)sybau`
                                    -# Shuts down the bot
                                    """,
                                inline: true
                            )
                        ]
                    )
                ]
            ), to: ctx)
            
        case "echo":
            let message = command.replacingOccurrences(of: "echo ", with: "")
            let authorid = author?.id
            client.sendMessage(DiscordMessage(content: "Hello! You said \(message)\n-# replied to <@\(authorid!)>"), to: ctx)
        case "ban":
            let cleanedArgs = args
                .replacingOccurrences(of: "<@!", with: "")
                .replacingOccurrences(of: "<@", with: "")
                .replacingOccurrences(of: ">", with: "")
            
            let banComponents = cleanedArgs.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            let user = String(banComponents[0])
            let reason = banComponents.count > 1 ? String(banComponents[1]) : "No reason (ask them for proof)"
            
            if let guild = message.guildId {
                let parsedGuild = parseGuild(guildId: guild, client: client)
                client.getGuildMember(by: author?.id ?? 0, on: guild) { member, response in
                    if let member = member {
                        let canBan = parsedGuild.canMember(member, DiscordPermissions(4), in: ctx)
                        if canBan {
                            if let userId = UInt64(user) {
                                let discordUserId = UserID(integerLiteral: userId)
                                client.guildBan(
                                    userId: discordUserId,
                                    on: guild,
                                    deleteMessageDays: 7,
                                    reason: "Banned by <@\(author?.id ?? 0)>: \(reason)"
                                ) { _, response in
                                    if let response = response {
                                        if response.statusCode == 200 || response.statusCode == 204 {
                                            client.sendMessage(
                                                DiscordMessage(
                                                    embeds: [
                                                        DiscordEmbed(
                                                            title: "<:success:1407930251698376725> Ban successful",
                                                            description:
                                                            """
                                                            Successfully banned user <@\(discordUserId.rawValue)>
                                                            Reason: \(reason)
                                                            """
                                                        )
                                                    ]
                                                ),
                                                to: ctx
                                            )
                                        } else {
                                            client.sendMessage(
                                                DiscordMessage(content: "<:fail:1407930342605717576> Unable to send message, plz check yer logs"),
                                                to: ctx
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let response = response {
                        logger.info("Response code: \(response.statusCode)")
                    }
                }
            }
            
        case "sybau":
            let authorw = author?.id
            let author2 = authorw!
            logger.info("User ID: \"\(author2)\" (AKA \"\((author?.username)!)\") ran sybau command")
            if "\(author2)" == "808606684837576714" {
                let time = Date().timeIntervalSince1970
                client.sendMessage(DiscordMessage(content: "Shutting down... in <t:\(Int(time) + 10):R>"), to: ctx)
                logger.warning("Shutting down in 10")
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    client.disconnect()
                    TempVars.shared.hasStarted.toggle()
                }
            }
            else {
                let noprms = noPerms(userID: author2, command: "sybau", prefix: prefix)
                client.sendMessage(DiscordMessage(content: noprms), to: ctx)
            }
        case "ping":
            Task {
                do {
                    let latencies = try await ping()
                    let apiLatency = latencies.first ?? -1
                    let wsLatency  = latencies.last ?? -1
                    
                    client.sendMessage(
                        DiscordMessage(
                            stringLiteral: "Pong!\nAPI latency: \(apiLatency)ms\nWebSocket latency: \(wsLatency)ms\nAverage: \((max(apiLatency, wsLatency) - min(apiLatency, wsLatency)) / 2)ms"
                        ),
                        to: ctx
                    )
                } catch {
                    logger.error("Ping failed: \(error.localizedDescription)")
                    client.sendMessage("Failed to measure latency, please contatc devs", to: ctx)
                }
            }
        default:
            return
        }
    }
}
