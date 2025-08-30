//
//  Location.swift
//  Swiftified-iOS
//
//  Created by GreenyCells (Mineturtlee) on 30/8/25.
//

import SwiftUI

struct Location: View {
    @ObservedObject private var LocationKAL = LocationKeepAlive.shared
    var body: some View {
        Text("Location: \(LocationKAL.variabeeee)")
    }
}

#Preview {
    Location()
}
