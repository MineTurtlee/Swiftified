//
//  Pinger.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 23/8/25.
//

import Foundation
import SwiftyPing

struct Pinger {
    
    func ping(_ hostname: String = "1.1.1.1", times: Int = -1) -> Int {
        let config: PingConfiguration = PingConfiguration(interval: 5, with: 56)
        let once = try? SwiftyPing(host: hostname, configuration: config, queue: DispatchQueue.global())
        var duration = 0
        once?.observer = { (response) in
            duration = Int(response.duration)
            if response.sequenceNumber == times {
                once?.stopPinging()
            }
        }
        try? once?.startPinging()
        return duration
    }
}
