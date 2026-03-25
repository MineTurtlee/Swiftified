import Discord
import Foundation

typealias CommandHandler = (DiscordClient, DiscordInteraction) async -> Void
typealias MessageCommandHandler = (DiscordClient, DiscordMessage, [String]) async -> Void

struct Cmd {
    let name: String
    let description: String
    let handler: CommandHandler
    let messageHandler: MessageCommandHandler?
}

protocol Command {
    static var name: String { get }
    static var description: String { get }
    static func handleSlash(_ client: DiscordClient, _ interaction: DiscordInteraction) async
    static func handleMessage(_ client: DiscordClient, _ message: DiscordMessage, _ args: [String]) async
}

// extension to auto-generate the Command struct so you never have to manually write it
extension Command {
    static var command: Cmd {
        Cmd(
            name: name,
            description: description,
            handler: { client, interaction in await handleSlash(client, interaction) },
            messageHandler: { client, message, args in await handleMessage(client, message, args) }
        )
    }
}

struct Commands {
    static var groups: [any CommandGroup.Type] {
        [
            Base.self
        ]
    }

    static var all: [String: Cmd] {
        Dictionary(uniqueKeysWithValues: list.map { ($0.name, $0) })
    }

    static var list: [Cmd] {
        groups.flatMap { group in
            group.commands.map { $0.command }
        }
    }
}