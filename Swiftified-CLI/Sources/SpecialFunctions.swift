//
//  SpecialFunctions.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 15/8/25.
//

import SwiftUI
import Discord
import Foundation
import Logging

fileprivate let logger = Logger(label: "SwiftifiedCommands")

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

func ping() async throws -> [Int] {
    guard let apiURL = URL(string: "https://discord.com/api/v10/gateway") else {
        logger.error("Invalid API URL.")
        return [0, 0]
    }

    guard let wsURL = URL(string: "https://gateway.discord.gg/?v=10&encoding=json") else {
        logger.error("Invalid WS URL.")
        return [0, 0]
    }
    
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    let session = URLSession(configuration: config)

    let apiStart = DispatchTime.now()
    let (_, _) = try await session.data(from: apiURL)
    let apiLatency = Int((DispatchTime.now().uptimeNanoseconds - apiStart.uptimeNanoseconds) / 1_000_000)

    let wsStart = DispatchTime.now()
    let (_, _) = try await session.data(from: wsURL)
    let wsLatency = Int((DispatchTime.now().uptimeNanoseconds - wsStart.uptimeNanoseconds) / 1_000_000)

    return [apiLatency, wsLatency]
}

func noPerms(userID: UserID, command: String, prefix: String) -> String {
    return "You are not allowed to use this command!\n-# Replied to <@\(userID)> • Command: \(prefix)\(command)"
}

func parseGuild(guildId: GuildID, client: DiscordClient) -> DiscordGuild {
    return client.guilds[guildId]!
}
