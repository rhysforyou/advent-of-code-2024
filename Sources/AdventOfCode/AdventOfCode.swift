import ArgumentParser
import Day1

@main
struct AdventOfCode: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "adventofcode",
        abstract: "Advent of Code 2024",
        subcommands: [Day1.self]
    )
}
