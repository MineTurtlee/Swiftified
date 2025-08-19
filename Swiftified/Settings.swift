//
//  Settings.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        @AppStorage("token") var token: String = ""
        NavigationStack {
            List {
                HStack {
                    Text("Bot Token")
                    TextField("Token here", text: $token)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
    }
}

#Preview {
    Settings()
}
