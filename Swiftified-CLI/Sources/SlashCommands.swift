//
//  SlashCommands.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 25/8/25.
//
import SwiftUI
import Discord
import Logging
import Foundation

fileprivate let logger = Logger(label: "SlashCommands")

/* func updateInteractionResponse(applicationId: String, token: String, newContent: String) async throws {
 let url = URL(string: "https://discord.com/api/v10/webhooks/\(applicationId)/\(token)/messages/@original")!
 
 var request = URLRequest(url: url)
 request.httpMethod = "PATCH"
 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 
 let body: [String: Any] = [
     "content": newContent
 ]
 
 request.httpBody = try JSONSerialization.data(withJSONObject: body)
 
 let (data, response) = try await URLSession.shared.data(for: request)
 
 if let httpResponse = response as? HTTPURLResponse {
     print("Status: \(httpResponse.statusCode)")
 }
 
 print(String(data: data, encoding: .utf8) ?? "")
} */

func createCallback(_ command: DiscordApplicationCommand?, response: HTTPURLResponse?) {
    if let cmd = command {
        logger.info("Successfully created command: \(cmd.name)")
    } else if let resp = response {
        logger.warning("Failed to create command. Status: \(resp.statusCode)")
    } else {
        logger.error("Unknown error while creating command.")
    }
}

class SlashCommands {
    var manager = BotManager.shared
    
    init(_ client: DiscordClient, initTree: Bool = false) {
        if (initTree == true && client.user!.bot == true) {
            client.createApplicationCommand(
                name: "test",
                description: "Test command for turtle to test wink wink",
                options: nil
            ) { command, response in
                createCallback(command, response: response)
            }
            client.createApplicationCommand(
                name: "help",
                description: "Help for Swiftified (well uh you know what, this thing is bad)",
                options: nil
            ) { command, response in
                createCallback(command, response: response)
            }
            client.createApplicationCommand(
                name: "ping",
                description: "Ping pong",
                options: nil
            ) { command, response in
                createCallback(command, response: response)
            }
            client.createApplicationCommand(
                name: "sybau",
                description: "Turn off the bot [Owner-only]", options: nil) { command, response in
                    createCallback(command, response: response)
                }
            client.createApplicationCommand(
                name: "echo",
                description: "Make the bot say anything",
                options: [
                    DiscordApplicationCommandOption(
                        type: .string,
                        name: "message",
                        description: "What to say",
                        isRequired: true
                    )
                ]
            ) { command, response in
                    createCallback(command, response: response)
            }
            client.createApplicationCommand(
                name: "ban",
                description: "Ban an user off of your server.",
                options: [DiscordApplicationCommandOption(type: .user, name: "user", description: "User to ban", isRequired: true),
                          DiscordApplicationCommandOption(type: .string, name: "reason", description: "Reason to ban")]
            ) { command, response in
                createCallback(command, response: response)
            }
        }
        else {
        }
    }
               
    @MainActor
    func invokeCommand(_ client: DiscordClient, interaction: DiscordInteraction, prefix: String) {
            let command = interaction.data?.name!
            let prefix = prefix
            let id = interaction.id
            let token = interaction.token
            
            switch command {
            case "test":
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
            
            case "help":
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
            
            case "ping":
                client.createInteractionResponse(
                    for: interaction.id,
                    token: interaction.token,
                    response: DiscordInteractionResponse(type: .deferredChannelMessageWithSource)
                )

                Task {
                    do {
                        let latencies = try await ping()
                        let apiLatency = latencies.first ?? -1
                        let wsLatency  = latencies.last ?? -1

                        try await updateMessage(
                            client,
                            interaction: interaction,
                            content: "Pong!\nAPI latency: \(apiLatency)ms\nWebSocket latency: \(wsLatency)ms\nAverage: \((max(apiLatency, wsLatency) - min(apiLatency, wsLatency)) / 2)ms"
                        )
                    } catch {
                        logger.error("Ping failed: \(error.localizedDescription)")
                        try? await updateMessage(
                            client,
                            interaction: interaction,
                            content: "Pong!\nFailed to measure latency."
                        )
                    }
                }
            
            case "sybau":
                let author = interaction.member?.id
                if author == 808606684837576714 {
                    let time = Int(Date().timeIntervalSince1970)
                    client.createInteractionResponse(for: interaction.id, token: interaction.token, response: DiscordInteractionResponse(type: .channelMessageWithSource, data: DiscordInteractionApplicationCommandCallbackData(content: "Shutting down in <t:\(time + 10):R>")))
                    logger.warning("Shutting down in 10")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        BotManager.shared.stopBot()
                        exit(0)
                    }
                }
                else {
                    let noshit = noPerms(userID: author!, command: "sybau", prefix: "/")
                    client.createInteractionResponse(for: id, token: token, response: DiscordInteractionResponse(type: .channelMessageWithSource, data: DiscordInteractionApplicationCommandCallbackData(content: noshit)))
                }
                
            case "echo":
                if let message = interaction.data?.options?.first(where: {$0.name == "message"}),
                   case let .string(text) = message.value {
                    client.createInteractionResponse(for: id, token: token, response: DiscordInteractionResponse(type: .channelMessageWithSource, data: DiscordInteractionApplicationCommandCallbackData(
                        content: "Hello! You said `\(text)`\n-# Replied to <@\(interaction.member!.user.id)>"
                    )))
                }
            case "ban":
                client.createInteractionResponse(for: id, token: token, response: DiscordInteractionResponse(type: .deferredChannelMessageWithSource))
                if let optns = interaction.data?.options {
                    let madedict = Dictionary(uniqueKeysWithValues: optns.map { ($0.name, $0)})
                    
                    if let guild = Optional(interaction.guildId) {
                        let author = interaction.member
                        let parsedGuild = parseGuild(guildId: guild, client: client)
                        if parsedGuild.canMember(author!, DiscordPermissions(arrayLiteral: .kickMembers), in: interaction.channelId) {
                            Task { @MainActor in
                                try? await updateMessage(client, interaction: interaction, content: "Still in progress, plz wait!")
                            }
                        }
                        else {
                            let darn = noPerms(userID: (author?.id)!, command: "ban", prefix: "/")
                            Task {
                                try? await updateMessage(client, interaction: interaction, content: darn)
                            }
                        }
                    }
                }
                
            default:
                return
            }
        }
    }
