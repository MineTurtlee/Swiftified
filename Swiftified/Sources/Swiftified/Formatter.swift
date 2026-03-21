import Foundation

struct Formatter {
    static func boardify(padding: Int, lines: [String]) -> [String] {
        // doubled (width x 2)
        let width: Int = lines.map {$0.count} .max()! + 4
        let border = String(repeating: "=", count: width)
        var finalized: [String] = []
        finalized.append("╔\(border)╗")

        for line in lines {
            let padding = String(repeating: " ", count: (width / 2) - lines.count)
            finalized.append("║\(padding)\(line)\(padding)║")
        }
        finalized.append("╚\(border)╝")

        return finalized
    }
}