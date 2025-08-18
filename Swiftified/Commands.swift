//
//  PrefixedCommands.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 15/8/25.
//

import Discord

struct Commands {
    class PrefixedCommands {
        init() {}
        func invokeCommand(command: String, client: DiscordClient, ctx: ChannelID, message: DiscordMessage) {
            let author = message.author
            if command == "help" {
                client.sendMessage(DiscordMessage(embeds: [DiscordEmbed(title: "Help", description: "- `sw!help`\n-# Print this message\n- sw!echo <message>\n-# Makes the bot says smt :3")]), to: ctx)
            }
            
            if command.starts(with:"echo") {
                let message = command.replacingOccurrences(of: "echo ", with: "")
                client.sendMessage(DiscordMessage(content: "Hello! You said \(message)\n-# replied to <@\(author?.id)>"), to: ctx)
            }
        }
    }
}
