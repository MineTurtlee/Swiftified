import Discord

class Bot: DiscordClientDelegate {
    public var client: DiscordClient!
    public var prefix: String

    init(token: String, tokenType: String? = "Bot", intents: DiscordGatewayIntents, commandPrefix: String) {
        prefix = commandPrefix
        client = DiscordClient(
            token: "\(tokenType!) \(token)",
            delegate: self,
            configuration: [
                .intents(intents)
            ]
        )
    }

    func start() {
        client.connect()
    }

    func close() {
        client.disconnect()
    }

    func client(_ client: DiscordClient, didConnect connected: Bool) {
        let username = client.user?.username ?? "unknown"
        let userID = client.user?.id.description ?? "unknown"
        let guilds = client.guilds.count
        let isBot = client.user?.bot ?? false

        let lines = [
            "Swiftified is online!",
            "User:     \(username)",
            "User ID:  \(userID)",
            "Guilds:   \(guilds)",
            "Is Bot:   \(isBot)",
        ]

        let board: [String] = Formatter.boardify(padding: 2, lines: lines)
        for line: String in board {
            print(line)
        }
    }

    func client(_ client: DiscordClient, didDisconnectWithReason reason: DiscordGatewayCloseReason, closed: Bool) {
        let reasonText: String
        switch reason {
            case .unknown:               reasonText = "Unknown reason"
            case .noNetwork:             reasonText = "Network dropped"
            case .normal:                reasonText = "Normal closure"
            case .goingAway:             reasonText = "Endpoint going away"
            case .unknownError:          reasonText = "Unknown error"
            case .unknownOpcode:         reasonText = "Unknown opcode sent"
            case .decodeError:           reasonText = "Decode error"
            case .notAuthenticated:      reasonText = "Not authenticated"
            case .authenticationFailed:  reasonText = "Authentication failed"
            case .alreadyAuthenticated:  reasonText = "Already authenticated"
            case .invalidSequence:       reasonText = "Invalid sequence number"
            case .rateLimited:           reasonText = "Rate limited"
            case .sessionTimeout:        reasonText = "Session timed out"
            case .invalidShard:          reasonText = "Invalid shard"
            case .unknownProtocol:       reasonText = "Unknown protocol"
            case .disconnected:          reasonText = "Disconnected"
            case .voiceServerCrash:      reasonText = "Voice server crashed"
            case .unknownEncryptionMode: reasonText = "Unknown encryption mode"
        default:                     reasonText = "Unrecognized reason (\(reason.rawValue))"
        }

        print("Bot disconnected: \(reasonText) (code: \(reason.rawValue)) || Reconnecting...")
        self.start()
    }

    func client(_ client: DiscordClient, didCreateMessage message: DiscordMessage) {
        if message.content!.starts(with: prefix) {
            var messagee = message.content!
            messagee.trimPrefix(prefix)
            Task {
                await Handlers.messageHandler(prefix: self.prefix, content: messagee)
            }
        }
    }

    func client(_ client: DiscordClient, didCreateInteraction interaction: DiscordInteraction) {

    }
}