import Discord

func noPerms(userID: UserID, command: String, prefix: String) -> String {
    return "You are not allowed to use this command!\n-# Replied to <@\(userID)> • Command: \(prefix)\(command)"
}

func parseGuild(guildId: GuildID, client: DiscordClient) -> DiscordGuild {
    return client.guilds[guildId]!
}