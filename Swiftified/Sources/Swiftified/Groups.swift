protocol CommandGroup {
    static var name: String { get }
    static var commands: [any Command.Type] { get }
}