import ArgumentParser
import Foundation
import Parsing

public struct Day1: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "day1",
        abstract: "Day 1: Historian Hysteria",
        discussion: """
            Calculates the difference between two lists in an input file.
            """
    )

    @Argument(help: "The path to the input file.")
    public var inputFilePath: String

    public init() {}

    public func run() throws {
        let input = try String(contentsOfFile: inputFilePath, encoding: .utf8)
        let (list1, list2) = try parseLists(input)
        let distance = calculateDistance(list1, list2)
        let similarity = calculateSimilarityScores(list1, list2)

        print("Part 1:", distance)
        print("Part 2:", similarity)
    }

    func parseLists(_ input: String) throws -> ([Int], [Int]) {
        let (list1, list2) = try ListsParser().parse(input)

        return (list1.sorted(), list2.sorted())
    }

    func calculateDistance(_ list1: [Int], _ list2: [Int]) -> Int {
        zip(list1, list2).reduce(0) { partialResult, tuple in
            partialResult + abs(tuple.0 - tuple.1)
        }
    }

    func calculateSimilarityScores(_ list1: [Int], _ list2: [Int]) -> Int {
        let list2Counts = Dictionary(list2.map { ($0, 1) }, uniquingKeysWith: +)
        return
            list1
            .map { $0 * list2Counts[$0, default: 0] }
            .reduce(0, +)
    }
}

struct ListsParser: Parser {
    var body: some Parser<Substring, ([Int], [Int])> {
        Many {
            Int.parser()
            Whitespace()
            Int.parser()
            "\n"
        }
        .map { tuples in
            tuples.reduce(into: ([Int](), [Int]())) { result, tuple in
                result.0.append(tuple.0)
                result.1.append(tuple.1)
            }
        }
    }
}
