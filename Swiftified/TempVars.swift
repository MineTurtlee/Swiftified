//
//  TempVars.swift
//  Swiftified
//
//  Created by GreenyCells (Mineturtlee) on 31/8/25.
//
import Foundation

final class TempVars: ObservableObject {
    static let shared = TempVars()
    @Published var hasStarted: Bool = false {
        didSet {
            disabled = !hasStarted
        }
    }
    @Published var disabled: Bool = true
    @Published var autoStart: Bool = false
    private init() {}
}
