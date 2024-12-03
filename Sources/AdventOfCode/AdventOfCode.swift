import ArgumentParser
import Day1
import Day2
import Day3

@main
struct AdventOfCode: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "adventofcode",
        abstract: "Advent of Code 2024",
        subcommands: [
            Day1.self,
            Day2.self,
            Day3.self,
        ]
    )
}
