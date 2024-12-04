import ArgumentParser
import Foundation

var instructionRegex: Regex<(Substring)> { /mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/ }
var doRegexp: Regex<(Substring)> { /do\(\)/ }
var dontRegexp: Regex<(Substring)> { /don't\(\)/ }
var mulRegex: Regex<(Substring, Substring, Substring)> { /mul\((\d{1,3}),(\d{1,3})\)/ }

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

        print("Part 1:", naiveCount(input: input))
        print("Part 2:", count(input: input))
    }

    private func naiveCount(input: String) -> Int {
        input.matches(of: mulRegex)
            .map { Int($0.1)! * Int($0.2)! }
            .reduce(0, +)
    }

    private func count(input: String) -> Int {
        var isEnabled = true
        var total = 0
        let instructions = input.matches(of: instructionRegex).map(\.0)

        for instruction in instructions {
            if instruction.contains(doRegexp) {
                isEnabled = true
            } else if instruction.contains(dontRegexp) {
                isEnabled = false
            } else if isEnabled, let mulMatch = instruction.firstMatch(of: mulRegex) {
                total += Int(mulMatch.1)! * Int(mulMatch.2)!
            }
        }

        return total
    }
}
