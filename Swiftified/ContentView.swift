//
//  ContentView.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

struct ContentView: View {
    @State private var manager = LocationKeepAlive()
    var body: some View {
        #if os(macOS)
            NavigationSplitView {
                VStack {
                    List {
                        NavigationLink("Main", destination: Main())
                        NavigationLink("Settings", destination: Settings())
                    }
                }
            }
            detail: {
                Main()
            }
        #elseif os(iOS)
            NavigationStack {
                List {
                    NavigationLink("Main", destination: Main())
                    NavigationLink("Settings", destination: Settings())
                }
            }
            .navigationTitle("Swiftified")
            .onAppear {
                let state = manager.checkPermission()
                switch state {
                case "didntAsk": manager.requestPermission()
                case "qrha": manager.requestPermission()
                default: return
                }
            }
        #endif
    }
}

#Preview {
    ContentView()
}
