import ArgumentParser
import Collections
import Parsing

package struct Day5: ParsableCommand {
    package static let configuration = CommandConfiguration(
        commandName: "day5",
        abstract: "Day 5: Print Queue",
        discussion: """
            Checks page printing order is valid based on a set of rules and pages.
            """
    )

    @Argument(help: "The path to the input file.")
    package var inputFilePath: String

    package init() {}

    package func run() throws {
        let rawInput = try String(contentsOfFile: inputFilePath, encoding: .utf8)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let input = try PageInputParser().parse(rawInput)

        print("Step 1:", input.correctnessScore)
        print("Step 2:", input.fixedIncorrectUpdatesScore)
    }
}

struct PageInput {
    let rules: [PageRule]
    let updates: [PageUpdate]

    var correctUpdates: [PageUpdate] {
        updates.filter { update in
            update.isCorrectlyOrdered(rules)
        }
    }

    var incorrectUpdates: [PageUpdate] {
        updates.filter { update in
            !update.isCorrectlyOrdered(rules)
        }
    }

    var correctnessScore: Int {
        correctUpdates
            .map(\.middlePage)
            .reduce(0, +)
    }

    var fixedIncorrectUpdatesScore: Int {
        incorrectUpdates
            .map { $0.withFixedPageOrder(rules: rules) }
            .map(\.middlePage)
            .reduce(0, +)
    }
}

struct PageRule {
    let before: Int
    let after: Int
}

struct PageUpdate {
    var pages: OrderedSet<Int>

    func isCorrectlyOrdered(_ rules: [PageRule]) -> Bool {
        rules.allSatisfy { rule in
            // Rules only apply if the update includes both pages
            guard let beforeIndex = pages.firstIndex(of: rule.before),
                let afterIndex = pages.firstIndex(of: rule.after)
            else {
                return true
            }

            return beforeIndex < afterIndex
        }
    }

    mutating func fixPageOrder(rules: [PageRule]) {
        while !isCorrectlyOrdered(rules) {
            for rule in rules {
                guard let beforeIndex = pages.firstIndex(of: rule.before),
                      let afterIndex = pages.firstIndex(of: rule.after)
                else {
                    continue
                }

                if beforeIndex > afterIndex {
                    pages.swapAt(beforeIndex, afterIndex)
                }
            }
        }
    }

    func withFixedPageOrder(rules: [PageRule]) -> PageUpdate {
        var fixedUpdate = self
        fixedUpdate.fixPageOrder(rules: rules)
        return fixedUpdate
    }

    var middlePage: Int {
        guard !pages.isEmpty else {
            return 0
        }
        let middleIndex = pages.count / 2
        return pages[middleIndex]
    }
}

struct PageInputParser: Parser {
    var body: some Parser<Substring, PageInput> {
        Parse(PageInput.init) {
            Many {
                PageRuleParser()
            } separator: {
                "\n"
            }
            "\n"
            Many {
                PageUpdateParser()
            } separator: {
                "\n"
            }
        }
    }
}

struct PageRuleParser: Parser {
    var body: some Parser<Substring, PageRule> {
        Parse(PageRule.init) {
            Int.parser()
            "|"
            Int.parser()
        }
    }
}

struct PageUpdateParser: Parser {
    var body: some Parser<Substring, PageUpdate> {
        Parse(PageUpdate.init) {
            Many(into: OrderedSet<Int>(), { $0.append($1) }) {
                Int.parser()
            } separator: {
                ","
            }
        }
    }
}
