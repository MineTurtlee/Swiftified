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

struct Commands {
    @AppStorage("prefix") var prefix: String = ""
    class PrefixedCommands {
        @ObservedObject var tmp = TempVars()
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
            
            if command.starts(with:"echo") {
                let message = command.replacingOccurrences(of: "echo ", with: "")
                let authorid = author?.id
                client.sendMessage(DiscordMessage(content: "Hello! You said \(message)\n-# replied to <@\(authorid!)>"), to: ctx)
            }
            if command == "sybau" {
                let authorw = author?.id
                let author2 = authorw!
                print("User ID: \"\(author2)\" (AKA \"\((author?.username)!)\") ran sybau command")
                if "\(author2)" == "808606684837576714" {
                    client.sendMessage("Shutting down...", to: ctx)
                    client.disconnect()
                    tmp.hasStarted = false
                }
                else {
                    let noprms = Commands().noPerms(userID: author2, command: "sybau")
                    client.sendMessage(DiscordMessage(content: noprms), to: ctx)
                }
            }
        }
    }
    class SlashCommands {
        init(_ client: DiscordClient, synctree: Bool) {
            if synctree == true {
                // Sync Applications Commands tree here!
                client.createApplicationCommand(name: "help", description: "Shows help")
            }
            else {
                
            }
        }
    }
    
    func noPerms(userID: UserID, command: String) -> String {
        return "You are not allowed to use this command!\n-# Replied to <@\(userID)> • Command: \(prefix)\(command)"
    }
}
