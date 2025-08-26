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
    @StateObject var manager = BotManager()
    @ObservedObject var tmp = TempVars.shared
    @AppStorage("prefix") var prefix: String = ""
    init() {}
    func invokeCommand(command: String, client: DiscordClient, ctx: ChannelID, message: DiscordMessage) {
        let author = message.author
        if command == "help" {
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
        }
            
        if command.starts(with: "echo") {
            let message = command.replacingOccurrences(of: "echo ", with: "")
            let authorid = author?.id
            client.sendMessage(DiscordMessage(content: "Hello! You said \(message)\n-# replied to <@\(authorid!)>"), to: ctx)
        }
        if command.starts(with: "ban") {
            let args = command.replacingOccurrences(of: "ban ", with: "")
                .replacingOccurrences(of: "<@!", with: "")
                .replacingOccurrences(of: "<@", with: "")
                .replacingOccurrences(of: ">", with: "")
            
            let components = args.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            
            let user = String(components[0])
            let reason = components.count > 1 ? String(components[1]) : "No reason (ask them for proof)"
            
            let guild = message.guildId
            if guild != nil {
                let parsedGuild = parseGuild(guildId: guild!, client: client)
                client.getGuildMember(by: (author?.id)!, on: guild!) { member, response in
                    if let member = member {
                        let dam = parsedGuild.canMember(member, DiscordPermissions(4), in: ctx)
                        if dam == true {
                            let user2 = UInt64(user)
                            let user3 = UserID(integerLiteral: user2!)
                            client.guildBan(
                                userId: user3,
                                on: guild!,
                                deleteMessageDays: 7,
                                reason: "Banned by <@\((author?.id)!)>: \(reason)",
                            ) { member, response in
                                if let response = response {
                                    if (response.statusCode == 200 || response.statusCode == 204) {
                                            client.sendMessage(
                                                DiscordMessage(
                                                    embeds: [
                                                        DiscordEmbed(
                                                            title: "<:success:1407930251698376725> Ban successful",
                                                            description:
                                                                """
Successfully banned user <@\(String(user3.rawValue))>
Reason: \(reason)
""")]), to: ctx)
                            }
                                    else {
                                        client.sendMessage(DiscordMessage(content: "<:fail:1407930342605717576> Unable to send message, plz check yer logs"), to: ctx)
                                    }
                                }
                                else {
                                    // client.sendMessage(DiscordMessage(content: "\(response.statusCode)"), to: ctx)
                                }
                            }
                        }
                    } else {
                    }
                    if let response = response {
                        logger.info("Response code: \(response.statusCode)")
                    }
                }
            }
        }
        
        if command == "sybau" {
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
        }
        if command == "ping" {
            guard let url = URL(string: "https://discord.com/api/v7/gateway") else {
                logger.error("Invalid ping URL.")
                client.sendMessage("Invalid ping url, please contact the devs", to: ctx)
                return
            }
            let startTime = Date()
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                let latency = Int(Date().timeIntervalSince(startTime) * 1000)
                
                if let error = error {
                    logger.warning("Request failed: \(error.localizedDescription)")
                    client.sendMessage("Request failed, please contact devs", to: ctx)
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    logger.error("Invalid response")
                    client.sendMessage("Invalid response, please contact devs", to: ctx)
                    return
                }
            }
        }
    }
}
