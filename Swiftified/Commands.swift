//
//  PrefixedCommands.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 15/8/25.
//

import SwiftUI
import Discord
import Foundation
import Logging

fileprivate var logger = Logger(label: "SwiftifiedCommands")

struct Commands {
    @AppStorage("prefix") var prefix: String = ""
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
                )
                                   , to: ctx)
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
            }
        }
    class SlashCommands {
        init(_ client: DiscordClient, initTree: Bool = false) {
            if initTree == true {
                client.createApplicationCommand(
                    name: "test",
                    description: "Test command for turtle to test wink wink",
                    options: nil
                ) { command, response in
                    if let cmd = command {
                        logger.info("Successfully created command: \(cmd.name)")
                    } else if let resp = response {
                        logger.warning("Failed to create command. Status: \(resp.statusCode)")
                    } else {
                        logger.error("Unknown error while creating command.")
                    }
                }
                
                client.createApplicationCommand(
                    name: "help",
                    description: "Help for Swiftified (well uh you know what, this thing is bad)",
                    options: nil
                ) { command, response in
                    if let cmd = command {
                        logger.info("Successfully created command: \(cmd.name)")
                    } else if let resp = response {
                        logger.warning("Failed to create command. Status: \(resp.statusCode)")
                    } else {
                        logger.error("Unknown error while creating command.")
                    }
                }
            }
            else {
            }
        }
                
        func invokeCommand(_ client: DiscordClient, interaction: DiscordInteraction) {
            let command = interaction.data?.name!
            let prefix = Commands().prefix
            
            if command == "test" {
                let response = DiscordInteractionResponse(
                    type: .channelMessageWithSource,
                    data: DiscordInteractionApplicationCommandCallbackData(
                        content: "It works!~",
                        embeds: [DiscordEmbed(
                            title: "Turtle once said...",
                            description: "I'm the cute little overseer..\n..wagtcjing over my own cosmo.."
                        )]
                    )
                )
                
                client.createInteractionResponse(
                    for: interaction.id,
                    token: interaction.token,
                    response: response
                ) { data, httpResponse in
                    if let http = httpResponse {
                        logger.info("Interaction responded with status: \(http.statusCode)")
                    } else {
                        logger.warning("Failed to get response from Discord")
                    }
                }
            }
            
            if command == "ping" {
                // Step A: send deferred response so Discord shows "thinking..."
                let deferred = DiscordInteractionResponse(type: .deferredChannelMessageWithSource)
                client.createInteractionResponse(for: interaction.id, token: interaction.token, response: deferred)
                var numAddress: String = ""

                let host = CFHostCreateWithName(nil,"gateway.discord.com" as CFString).takeRetainedValue()
                CFHostStartInfoResolution(host, .addresses, nil)
                var success: DarwinBoolean = false
                if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
                    let theAddress = addresses.firstObject as? NSData {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                                   &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                        numAddress = String(cString: hostname)
                    }
                }
                    // Step C: run your Pinger against the resolved IP
                let latency = Pinger().ping(numAddress, times: 1)

                    // Step D: send the latency back as an updated message
                let url = URL(string: "https://discord.com/api/v10/webhooks/\(client.user!.id)/\(interaction.token)/messages/@original")!
                var request = URLRequest(url: url)
                request.httpMethod = "PATCH"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONSerialization.data(withJSONObject: [
                    "content": "Pong! Latency: \(latency) ms"
                ])

                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Edit error: \(error)")
                    }
                    if let http = response as? HTTPURLResponse {
                        print("Edited original message, status: \(http.statusCode)")
                    }
                }.resume()
            }
            
            if command == "help" {
                let response = DiscordInteractionResponse(type: .channelMessageWithSource, data: DiscordInteractionApplicationCommandCallbackData(
                    embeds: [DiscordEmbed(
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
                    )]
                ))
                client.createInteractionResponse(for: interaction.id, token: interaction.token, response: response)
            }
        }
    }
}


func noPerms(userID: UserID, command: String, prefix: String) -> String {
    return "You are not allowed to use this command!\n-# Replied to <@\(userID)> • Command: \(prefix)\(command)"
}

func parseGuild(guildId: GuildID, client: DiscordClient) -> DiscordGuild {
    return client.guilds[guildId]!
}
