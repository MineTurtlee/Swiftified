import Discord
import Foundation
import Dispatch

struct BotManager {
    private var bot: Bot

    init(token: String, tokenType: String) {
        bot = Bot(token: token, tokenType: tokenType, intents: .allIntents, commandPrefix: "sw[")
    }

    func start() {
        bot.start()
    }

    func close() {
        bot.close()
    }
}