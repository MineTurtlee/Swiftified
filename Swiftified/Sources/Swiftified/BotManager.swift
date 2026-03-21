import Discord
import Foundation
import Dispatch

struct BotManager {
    private var bot: Bot

    init(token: String, tokenType: String) {
        bot = Bot(token: String, tokenType: String)
    }

    func start() {
        bot.start()
    }

    func close() {
        bot.close()
    }
}