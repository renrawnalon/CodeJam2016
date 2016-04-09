//: [Previous](@previous)

import Foundation
import XCPlayground

var str = "Hello, playground"

func toInts(acc: [Int], next: String) -> [Int] {
    if next == "+" {
        return acc + [1]
    } else {
        return acc + [0]
    }
}

func main() {
    let inputFileName = "B-large.in"
    let inputFilePath = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent(inputFileName)
    let outputFileName = "B-large.out"
    let outputFilePath = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent(outputFileName)
    let contents: String?
    
    do {
        contents = try String(contentsOfURL: inputFilePath)
    } catch {
        contents = nil
    }
    
    let input = Array(contents?.componentsSeparatedByString("\n").dropFirst() ?? []).filter {
        !$0.isEmpty
    }
    if (input.count == 0) {
        print("Invalid Input")
        return
    }
    
    var output = ""
    for (index, value) in input.enumerate() {
        let result = countFlips(value.characters.map{"\($0)"}.reduce([], combine: toInts))
        let outputLine = "Case #\(index + 1): \(result)"

        output = output + outputLine + "\n"
    }
    
    do {
        try output.writeToURL(outputFilePath, atomically: true, encoding: NSUTF8StringEncoding)
    } catch {
        print("Couldn't write to file")
    }
}

// Input
//
// 5
// -
// -+
// +-
// +++
// --+-

// Output
//
// Case #1: 1
// Case #2: 1
// Case #3: 2
// Case #4: 0
// Case #5: 3

func countFlips(input: [Int]) -> Int {
    var count = 0
    var lastPancake = 1
    for pancake in input.reverse() {
        if lastPancake == pancake {
            continue
        } else {
            count += 1
            lastPancake = pancake
        }
    }
    
    return count
}

main()

//: [Next](@next)
