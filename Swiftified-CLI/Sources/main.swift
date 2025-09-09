import Foundation
import Logging

fileprivate var logger = Logger(label: "Swiftified")

struct DataCodable: Codable {
    let token: String
    let tokenType: String
    let prefix: String
}

struct MyTool {
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
            
        } catch {
            print("Error: \(error)")
        }
    }
}
