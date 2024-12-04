import Foundation
import Testing
@testable import Day3

@Test func testNaiveCount() throws {
    let inputURL = try #require(Bundle.module.url(forResource: "example3", withExtension: "txt"))
    let input = try String(contentsOf: inputURL, encoding: .utf8)
    #expect(Day3.naiveCount(input: input) == 6)
}
