import ArgumentParser
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
    }
}

struct PageInput {
    let rules: [PageRule]
    let updates: [PageUpdate]

    var correctUpdates: [PageUpdate] {
        updates.filter { update in
            rules.allSatisfy { rule in
                update.isCorrectlyOrdered(rule)
            }
        }
    }

    var incorrectUpdates: [PageUpdate] {
        updates.filter { update in
            rules.contains { rule in
                !update.isCorrectlyOrdered(rule)
            }
        }
    }

    var correctnessScore: Int {
        correctUpdates
            .map(\.middlePage)
            .reduce(0, +)
    }
}

struct PageRule {
    let before: Int
    let after: Int
}

struct PageUpdate {
    var pages: [Int]

    func isCorrectlyOrdered(_ rule: PageRule) -> Bool {
        // Rules only apply if the update includes both pages
        guard let beforeIndex = pages.firstIndex(of: rule.before),
            let afterIndex = pages.firstIndex(of: rule.after)
        else {
            return true
        }

        return beforeIndex < afterIndex
    }

    mutating func correctOrder(_ rule: PageRule) {
        guard !isCorrectlyOrdered(rule) else { return }

        guard pages.firstIndex(of: rule.before) != nil,
            pages.firstIndex(of: rule.after) != nil
        else {
            return
        }

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
            Many {
                Int.parser()
            } separator: {
                ","
            }
        }
    }
}
