//
//  Main.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

final class TempVars: ObservableObject {
    static let shared = TempVars()
    @Published var hasStarted: Bool = false
    private init() {}
}

struct Main: View {
    @StateObject private var manager = BotManager()
    private var bot = Bot.shared
    @ObservedObject private var tmp = TempVars.shared
    @AppStorage("statusMode") public var selection = "Nothing"
    let statuses = ["Custom", "Streaming", "Listening", "Playing", "Watching", "Nothing"]
    @AppStorage("statusName") public var statusName: String = ""
    @AppStorage("statuss") public var status = "Online"
    @AppStorage("prefix") public var prefix = "!"
    let statuslist = ["Online", "Idle", "Do not disturb", "Offline (Invisible)"]
    var body: some View {
        
        NavigationStack {
            List {
                HStack {
                    Text("Prefix")
                    TextField("Prefix here", text: $prefix)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150, alignment: .trailing)
                }
                Picker("Select a status", selection: $status) {
                    ForEach(statuslist, id: \.self) {
                        Text($0)
                    }
                }
                .frame(width: 250, alignment: .trailing)
                Picker("Select a status mode", selection: $selection) {
                    ForEach(statuses, id: \.self) {
                        Text($0)
                    }
                }
                .frame(width: 300, alignment: .trailing)
                if selection == "Nothing" {
                }
                else {
                    HStack {
                        Text("Status Name")
                        TextField("Status name here...", text: $statusName)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 300, alignment: .trailing)
                    }
                }
                HStack {
                    Text("Start, or stop the bot!")
                    Button(action: {
                        tmp.hasStarted.toggle()
                        manager.startBot()
                    }) {
                        Text(tmp.hasStarted ? "Stop" : "Start")
                    }
                }
                HStack {
                    Text("Restart the bot (use when refreshing presence)")
                    let btn = Button("Restart") {
                        manager.stopBot()
                        TempVars.shared.hasStarted.toggle()
                        manager.startBot()
                        TempVars.shared.hasStarted.toggle()
                    }
                    .frame(alignment: .trailing)
                    if TempVars.shared.hasStarted == true {
                        btn.disabled(true)
                    }
                    btn
                }
            }
        }
        .environmentObject(tmp)
    }
}

#Preview {
    Main()
}
