//
//  Main.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 10/8/25.
//

import SwiftUI

final class TempVars: ObservableObject {
    static let shared = TempVars()
    @Published var hasStarted: Bool = false {
        didSet {
            disabled = !hasStarted
        }
    }
    @Published var disabled: Bool = true
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
                if tmp.hasStarted == false {
                    Button(action: {
                        tmp.hasStarted = true
                        manager.startBot()
                    }, label: {Text("Start")})
                    .frame(alignment: .trailing)
                }
                else {
                    Button(action: {
                        tmp.hasStarted = false
                        manager.stopBot()
                    }, label: {Text("Stop")})
                    .frame(alignment: .trailing)
                }
            }
                HStack {
                    Text("Restart the bot (use when refreshing presence)")
                    Button("Restart") {
                        manager.stopBot()
                        TempVars.shared.hasStarted.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            manager.startBot()
                            TempVars.shared.hasStarted.toggle()
                        }
                    }
                    .frame(alignment: .trailing)
                    .disabled(TempVars.shared.disabled)
                }
            }
        }
        .environmentObject(tmp)
    }
}

#Preview {
    Main()
}
