import ArgumentParser

public struct Day4: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "day4",
        abstract: "Day 4: Ceres Search",
        discussion: """
            Finds instances of XMAS in a word search
            """
    )

    @Argument(help: "The path to the input file.")
    public var inputFilePath: String

    public init() {}

    public func run() throws {
        let input = try String(contentsOfFile: inputFilePath, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let wordSearch = WordSearch(fromString: input)

        print("Part 1:", wordSearch.countOccurrences(ofPatterns: part1Patterns))
        print("Part 2:", wordSearch.countOccurrences(ofPatterns: part2Patterns))
    }
}

// Look up table for the patterns of the word "XMAS"
let part1Patterns: [[(Character, Int, Int)]] = [
    [("X", +0, +0), ("M", +0, -1), ("A", +0, -2), ("S", +0, -3)],  // Up
    [("X", +0, +0), ("M", +1, -1), ("A", +2, -2), ("S", +3, -3)],  // Up-Right
    [("X", +0, +0), ("M", +1, +0), ("A", +2, +0), ("S", +3, +0)],  // Right
    [("X", +0, +0), ("M", +1, +1), ("A", +2, +2), ("S", +3, +3)],  // Down-Right
    [("X", +0, +0), ("M", +0, +1), ("A", +0, +2), ("S", +0, +3)],  // Down
    [("X", +0, +0), ("M", -1, +1), ("A", -2, +2), ("S", -3, +3)],  // Down-Left
    [("X", +0, +0), ("M", -1, +0), ("A", -2, +0), ("S", -3, +0)],  // Left
    [("X", +0, +0), ("M", -1, -1), ("A", -2, -2), ("S", -3, -3)],  // Up-Left
]

// Look up table for 'X's of MAS
let part2Patterns: [[(Character, Int, Int)]] = [
    [("A", 0, 0), ("M", -1, -1), ("S", +1, +1), ("M", +1, -1), ("S", -1, +1)],
    [("A", 0, 0), ("S", -1, -1), ("M", +1, +1), ("M", +1, -1), ("S", -1, +1)],
    [("A", 0, 0), ("M", -1, -1), ("S", +1, +1), ("S", +1, -1), ("M", -1, +1)],
    [("A", 0, 0), ("S", -1, -1), ("M", +1, +1), ("S", +1, -1), ("M", -1, +1)],
]

struct WordSearch {
    var letters: [[Character]]
    var rowCount: Int { letters.count }
    var colunmCount: Int { letters.first?.count ?? 0 }

    init(fromString string: String) {
        letters = string.split(separator: "\n").map { Array($0) }
    }

    func countOccurrences(ofPatterns patterns: [[(Character, Int, Int)]]) -> Int {
        patterns.map(countOccurrences(ofPattern:)).reduce(0, +)
    }

    func countOccurrences(ofPattern pattern: [(Character, Int, Int)]) -> Int {
        var count = 0
        for row in 0..<rowCount {
            for col in 0..<colunmCount {
                for (index, (letter, rowOffset, colOffset)) in pattern.enumerated() {
                    let newRow = row + rowOffset
                    let newCol = col + colOffset
                    guard newRow >= 0,
                        newRow < rowCount,
                        newCol >= 0,
                        newCol < colunmCount,
                        letters[newRow][newCol] == letter
                    else {
                        break
                    }
                    if index == pattern.count - 1 {
                        count += 1
                    }
                }

            }
        }
        return count
    }
}
