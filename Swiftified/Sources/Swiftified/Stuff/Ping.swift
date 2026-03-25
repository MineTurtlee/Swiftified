import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Discord
import Logging

fileprivate let logger = Logger(label: "SwiftifiedStuff")

func ping() async throws -> [Int] {
    guard let apiURL = URL(string: "https://discord.com/api/v10/gateway") else {
        logger.error("Invalid API URL.")
        return [0, 0]
    }

    guard let wsURL = URL(string: "https://gateway.discord.gg/?v=10&encoding=json") else {
        logger.error("Invalid WS URL.")
        return [0, 0]
    }
    
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    let session = URLSession(configuration: config)

    let apiStart = DispatchTime.now()
    let (_, _) = try await session.data(from: apiURL)
    let apiLatency = Int((DispatchTime.now().uptimeNanoseconds - apiStart.uptimeNanoseconds) / 1_000_000)

    let wsStart = DispatchTime.now()
    let (_, _) = try await session.data(from: wsURL)
    let wsLatency = Int((DispatchTime.now().uptimeNanoseconds - wsStart.uptimeNanoseconds) / 1_000_000)

    return [apiLatency, wsLatency]
}

