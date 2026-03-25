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

    static func handleSlash(_ client: DiscordClient, interaction: DiscordInteraction) async {
        var latencies = try! await ping()
        interaction.editInteraction(
            client: client,
            interaction: interaction, 
            data: DiscordMessage.Edit(
                components: [
                    DiscordMessageComponent.container(
                        components: [
                            DiscordMessageComponent.textDisplay(content: "# Ping statistics"),
                            DiscordMessageComponent.separator(),
                            DiscordMessageComponent.textDisplay(content: 
                                """
                                API latency: \(latencies[0])
                                Websocket latency: \(latencies[1])
                                """
                            )
                        ]
                    )
                ]
            )
        )
    }
    
    static func handleMessage(_ message: DiscordMessage, _ args: [String]) async {
        //
    }
}