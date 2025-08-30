//
//  Settings.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

struct Settings: View {
    let typelist = ["Bot", "User"]
    @AppStorage("token") var token: String = ""
    @AppStorage("tokenType") var tokenType: String = "Bot"
    var body: some View {
        NavigationStack {
            List {
                Picker("Token type", selection: $tokenType) {
                    ForEach(typelist, id: \.self) {
                        Text($0)
                    }
                }
                .frame(width: 150)
                HStack {
                    Text("Bot Token")
                    TextField("Token here", text: $token)
                    #if os(macOS)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                    #elseif os(iOS)
                        .textFieldStyle(.plain)
                        .multilineTextAlignment(.trailing)
                    #endif
                }
            }
        }
    }
}

#Preview {
    Settings()
}
