//
//  ContentView.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//
// MTM5OTUwNDU4NDQzMDQ1Mjc4Ng.GkYZ5Q.2lhQIhYYoGuluoyJ8UEisg3SKP6JoFFZ8pKmmo

import SwiftUI

struct ContentView: View {
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
