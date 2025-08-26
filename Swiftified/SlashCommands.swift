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

class SlashCommands {
    @StateObject var manager = BotManager()
    @ObservedObject var tmp = TempVars.shared
    @AppStorage("prefix") var prefix: String = "!"
    func createCallback(_ command: DiscordApplicationCommand, response: HTTPURLResponse) {
        if let cmd = Optional(command) {
            logger.info("Successfully created command: \(cmd.name)")
        } else if let resp = Optional(response) {
            logger.warning("Failed to create command. Status: \(resp.statusCode)")
        } else {
            logger.error("Unknown error while creating command.")
        }
    }
    func updateMessage(_ client: DiscordClient, interaction: DiscordInteraction, content: String) async throws {
        let url = URL(string: "https://discord.com/api/v10/webhooks/\(client.user!.id)/\(interaction.token)/messages/@original")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "content": content
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            logger.info("Status: \(httpResponse.statusCode)")
        }
    }
    
    init(_ client: DiscordClient, initTree: Bool = false) {
        if initTree == true {
            client.createApplicationCommand(
                name: "test",
                description: "Test command for turtle to test wink wink",
                options: nil
            ) { command, response in
                self.createCallback(command!, response: response!)
            }
            client.createApplicationCommand(
                name: "help",
                description: "Help for Swiftified (well uh you know what, this thing is bad)",
                options: nil
            ) { command, response in
                self.createCallback(command!, response: response!)
            }
            client.createApplicationCommand(
                name: "ping",
                description: "Ping pong",
                options: nil
            ) { command, response in
                self.createCallback(command!, response: response!)
            }
            client.createApplicationCommand(
                name: "sybau",
                description: "Turn off the bot [Owner-only]", options: nil) { command, response in
                    self.createCallback(command!, response: response!)
                }
        }
        else {
        }
    }
                
        func invokeCommand(_ client: DiscordClient, interaction: DiscordInteraction) {
            let command = interaction.data?.name!
            let prefix = prefix
            let id = interaction.id
            let token = interaction.token
            
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
            
            if command == "ping" {
                client.createInteractionResponse(for: interaction.id, token: interaction.token, response: DiscordInteractionResponse(type: .deferredChannelMessageWithSource))
                
                guard let url = URL(string: "https://discord.com/api/v10/gateway") else {
                    logger.error("Invalid ping URL.")
                    Task {
                        try? await self.updateMessage(
                            client,
                            interaction: interaction,
                            content: "Invalid ping URL, please contact the devs"
                        )
                    }
                    return
                }
                let startTime = Date()
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    let latency = Int(Date().timeIntervalSince(startTime) * 1000)
                    
                    if let error = error {
                        logger.warning("Request failed: \(error.localizedDescription)")
                        Task {
                            try? await self.updateMessage(
                                client,
                                interaction: interaction,
                                content: "Request failed, please contact the devs"
                            )
                        }
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        logger.error("Invalid response")
                        client.createInteractionResponse(for: interaction.id, token: interaction.token, response: DiscordInteractionResponse(type: .channelMessageWithSource, data: DiscordInteractionApplicationCommandCallbackData(content: "Invalid response")))
                        return
                    }
                    Task {
                        try? await self.updateMessage(
                            client,
                            interaction: interaction,
                            content: "Pong! The latency is \(latency)ms"
                        )
                    }
                }
                task.resume()
            }
            
            if command == "sybau" {
                let author = interaction.member?.id
                if author == 808606684837576714 {
                    let time = Int(Date().timeIntervalSince1970)
                    client.createInteractionResponse(for: interaction.id, token: interaction.token, response: DiscordInteractionResponse(type: .channelMessageWithSource, data: DiscordInteractionApplicationCommandCallbackData(content: "Shutting down in <t:\(time + 10):R>")))
                    logger.warning("Shutting down in 10")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        client.disconnect()
                        TempVars.shared.hasStarted.toggle()
                    }
                }
                else {
                    let noshit = noPerms(userID: author!, command: "sybau", prefix: "/")
                    client.createInteractionResponse(for: id, token: token, response: DiscordInteractionResponse(type: .channelMessageWithSource, data: DiscordInteractionApplicationCommandCallbackData(content: noshit)))
                }
            }
        }
    }
