//
//  ContentView.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

struct ContentView: View {
    #if os(iOS)
    @StateObject private var manager = LocationKeepAlive()
    #endif
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
                    NavigationLink("Location", destination: Location())
                }
            }
            .navigationTitle("Swiftified")
            .onAppear {
                let state = manager.checkPermission()
                if state == .notDetermined {
                    manager.requestPermission()
                    manager.requestPermission()
                }
                else if state == .authorizedWhenInUse {
                    manager.requestPermission()
                }
            }
        #endif
    }
}

#Preview {
    ContentView()
}
