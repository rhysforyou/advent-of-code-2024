import Algorithms
import ArgumentParser
import Foundation
import Parsing

public struct Day2: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "day2",
        abstract: "Day 2: Red-Nosed Reports",
        discussion: """
            Determines which reactors are safed based on a series of input reports.
            """
    )

    @Argument(help: "The path to the input file.")
    public var inputFilePath: String

    @Flag(help: "Enables the Problem Dampener")
    public var dampen: Bool = false

    public init() {}

    public func run() throws {
        let input = try String(contentsOfFile: inputFilePath, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let reports = try ReportsParser().parse(input)

        let safeReportsCount = reports.count(where: \.isSafe)
        let safeDampenedReportsCount = reports.count { report in
            report.dampenedLevelsCombinations
                .lazy
                .map(Report.init)
                .contains(where: \.isSafe)
        }
        print("Part 1:", safeReportsCount)
        print("Part 2:", safeDampenedReportsCount)
    }
}

struct Report {
    var levels: [Int]
    var deltas: [Int]

    init(levels: [Int]) {
        self.levels = levels
        self.deltas = zip(levels, levels.dropFirst()).map(-)
    }

    var areAllDeltasSteady: Bool {
        deltas.allSatisfy { abs($0) <= 3 }
    }

    var areAllDeltasSameDirection: Bool {
        let isIncreasing = levels[0] < levels[1]
        return deltas.allSatisfy { ($0 < 0) == isIncreasing }
    }

    var areAllDeltasNonZero: Bool {
        deltas.allSatisfy { $0 != 0 }
    }

    var dampenedLevelsCombinations: CombinationsSequence<[Int]> {
        levels.combinations(ofCount: levels.count - 1)
    }

    var isSafe: Bool {
        return areAllDeltasSteady
            && areAllDeltasSameDirection
            && areAllDeltasNonZero
    }
}

struct ReportsParser: Parser {
    var body: some Parser<Substring, [Report]> {
        Many {
            ReportParser()
        } separator: {
            "\n"
        }
    }
}

struct ReportParser: Parser {
    var body: some Parser<Substring, Report> {
        Parse(Report.init) {
            Many {
                Int.parser()
            } separator: {
                Whitespace(.horizontal)
            }
        }
    }
}
