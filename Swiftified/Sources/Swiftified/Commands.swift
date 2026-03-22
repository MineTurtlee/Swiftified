import Discord
import Foundation

typealias CommandHandler = (DiscordInteraction) async -> Void
typealias MessageCommandHandler = (DiscordMessage, [String]) async -> Void

struct Cmd {
    let name: String
    let description: String
    let handler: CommandHandler
    let messageHandler: MessageCommandHandler?
}

protocol Command {
    static var name: String { get }
    static var description: String { get }
    static func handleSlash(_ interaction: DiscordInteraction) async
    static func handleMessage(_ message: DiscordMessage, _ args: [String]) async
}

// extension to auto-generate the Command struct so you never have to manually write it
extension Command {
    static var command: Cmd {
        Cmd(
            name: name,
            description: description,
            handler: { interaction in await handleSlash(interaction) },
            messageHandler: { message, args in await handleMessage(message, args) }
        )
    }
}

struct Commands {
    static var groups: [any CommandGroup.Type] {
        [
            
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