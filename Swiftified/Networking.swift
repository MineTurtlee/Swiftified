import Network
import Logging

fileprivate let logger = Logger(label: "SwiftifiedNetworking")

struct Networking {
    func resolveHostNW(_ host: String, completion: @escaping (String?) -> Void) {
        let params = NWParameters.tcp
        let port: NWEndpoint.Port = 80
        let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: port)

        let connection = NWConnection(to: endpoint, using: params)

        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                if let remote = connection.currentPath?.remoteEndpoint {
                    switch remote {
                    case .hostPort(let resolvedHost, _):
                        var ipString = resolvedHost.debugDescription
                        // Remove "ipv4:" / "ipv6:" prefixes if present
                        if ipString.hasPrefix("ipv4:") {
                            ipString = String(ipString.dropFirst("ipv4:".count))
                            logger.info("IP: \(ipString)")
                        } else if ipString.hasPrefix("ipv6:") {
                            ipString = String(ipString.dropFirst("ipv6:".count))
                            logger.info("IP: \(ipString)")
                        }
                        completion(ipString)
                    default:
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
                connection.cancel()
            case .failed, .cancelled:
                completion(nil)
            default:
                break
            }
        }

        connection.start(queue: .global())
    }
}
