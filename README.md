# Advent of Code 2024

This package contains my solutons for the [Advent of Code 2024](https://adventofcode.com/2024) puzzles. The project is written in Swift and uses Swift Argument Parser to expose a command line interface which can be used to run each solution.

Code is organised into separate libraries for each day under `./Sources/Day[N]/` and there's an executable target in `./Sources/AdventOdCode/` which exposes each of those solutions via a CLI.

This project also makes use of a few open-source libraries to make things easier:

- [apple/swift-argument-parser](https://github.com/apple/swift-argument-parser) to provide a nice command line interface
- [pointfreeco/swift-parsing](https://github.com/pointfreeco/swift-parsing) for parsing input files into useable data structures
- [apple/swift-algorithms](https://github.com/swift-algorithms) for some useful algorithms like getting every permutation of a set

## Usage

This project uses the Swift Package Manager, and requires a Swift 6 toolchain to build. With a recent version of Xcode (16.0 and up), you should be able to install dependencies and run the CLI with the following command:

```shell
% swift run adventofcode day1 Inputs/day1.txt
```
