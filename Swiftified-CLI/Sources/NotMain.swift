import Foundation
import Logging

struct DataCodable: Codable {
    let token: String
    let tokenType: String
    let prefix: String
}

@main
struct Swiftified {
    static fileprivate let logger = Logger(label: "Swiftified")
    @MainActor static func main() {
        let args = CommandLine.arguments

        guard args.count > 1 else {
            logger.info("Usage: swiftified <filename>")
            exit(1)
        }

        let path = args[1]
        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            let config = try JSONDecoder().decode(DataCodable.self, from: data)
            BotManager.shared.startBot(config.token, config.tokenType, config.prefix)
        } catch {
            logger.error("\(error)")
        }
    }
}

