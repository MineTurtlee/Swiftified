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
        @State var lat = LocationKAL.variabeeee.latitude
        @State var long = LocationKAL.variabeeee.longitude
        Text("Location: \(lat), \(long)")
    }
}

#Preview {
    Location()
}
