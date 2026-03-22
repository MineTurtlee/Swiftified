import Discord

struct Base: CommandGroup {
    static let name: String = "base"
    static let commands: [any Command.Type] = [
        Ping.self
    ]
}

struct Ping: Command {
    static let name = "ping"
    static let description = "Ping pong :)"

    static func handleSlash(_ interaction: DiscordInteraction) async {
        //
    }
    
    static func handleMessage(_ message: DiscordMessage, _ args: [String]) async {
        //
    }
}