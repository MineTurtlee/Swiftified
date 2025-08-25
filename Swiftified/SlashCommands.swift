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
