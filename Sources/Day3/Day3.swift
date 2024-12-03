import ArgumentParser
import Foundation

public struct Day3: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "day3",
        abstract: "Day 3: Mull It Over",
        discussion: """
            Determines which reactors are safed based on a series of input reports.
            """
    )

    @Argument(help: "The path to the input file.")
    public var inputFilePath: String

    public init() {}

    public func run() throws {
        let input = try String(contentsOfFile: inputFilePath, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let mulRegexp = /mul\((\d{1,3}),(\d{1,3})\)/
        let total = input.matches(of: mulRegexp)
            .map { Int($0.1)! * Int($0.2)! }
            .reduce(0, +)

        print(total)
    }
}
