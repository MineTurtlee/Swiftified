import Discord
import Foundation

typealias CommandHandler = (DiscordInteraction) async -> Void
typealias MessageCommandHandler = (DiscordMessage, [String]) async -> Void

struct Command {
    let name: String
    let description: String
    let handler: CommandHandler
    let messageHandler: MessageCommandHandler?
}

struct Commands {
    static var all: [String: Command] {
        Dictionary(uniqueKeysWithValues: list.map { ($0.name, $0) })
    }

    
    static var list: [Command] {  // 👈 var not let
        [
            Command(
                name: "ping",
                description: "Pong!",
                handler: { interaction in
                    
                },
                messageHandler: { message, args in
                    
                }
            ),
        ]
    }
}