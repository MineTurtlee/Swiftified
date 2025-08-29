//
//  ContentView.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

struct ContentView: View {
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
        #endif
    }
}

#Preview {
    ContentView()
}
