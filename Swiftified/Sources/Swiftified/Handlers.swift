import Discord

struct Handlers {
    static func messageHandler(prefix: String, message: DiscordMessage, args: [String]) async {
        var cmd = message.content!
        cmd.trimPrefix(prefix)

        guard let command = Commands.all[cmd] else {
            print("Unknown command: \(cmd)")
            return
        }

        // await command.messageHandler()
    }
    
    static func interactionHandler(interaction: DiscordInteraction) async {
        guard let name = interaction.data?.name else { return }
        
        guard let command = Commands.all[name] else {
            print("Unknown command: \(name)")
            return
        }
        
        await command.handler(interaction)
    }
}