//
//  Responses.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 19/8/25.
//

import Discord
import Logging

fileprivate var logger = Logger(label: "SwiftifiedResponses")

class Responses {
    init(client: DiscordClient, message: DiscordMessage) {
        let ctx = message.channelId
        if let content = message.content {
            let pattern = #"(?i)\bkms\b|\bk(i|!|1|¡|l)(1|l|i|!|¡)(1|l|i|!|¡) my(s|5)(e|3)+"#
            if content.range(of: pattern, options: .regularExpression) != nil {
                client.sendMessage("Click into the image and read both the text, big and small.", to: ctx)
                client.sendMessage("https://cdn.discordapp.com/attachments/1024941835891785771/1385086676296269895/IMG_3110.jpg?ex=689aa97d&is=689957fd&hm=d2ce5b01edb07ab92002f8cacdb155c9fb30ab6346177160c991126d38011ffb&", to: ctx)
            }
        }
    }
}
