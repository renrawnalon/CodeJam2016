//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

var str = "Hello, playground"

func toInts(acc: [Int], next: String) -> [Int] {
    if let value = Int(next) {
        return acc + [value]
    } else {
        return acc
    }
}

func main() {
    let inputFileName = "countSheepInput.txt"
    let inputFilePath = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent(inputFileName)
    let outputFileName = "countSheepOutput.txt"
    let outputFilePath = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent(outputFileName)
    let contents: String?
    
    do {
        contents = try String(contentsOfURL: inputFilePath)
    } catch {
        contents = nil
    }
    
    guard let unfilteredLines = contents?.componentsSeparatedByString("\n") else {
        print("Invalid Input")
        return
    }
    
    let input = unfilteredLines.reduce([], combine: toInts)
    
    guard let testCaseCount = input.first else {
        print("No values input")
        return
    }
    
    let testValues = Array(input.dropFirst())
    
    guard testCaseCount == testValues.count else {
        print("Test case count does not match the number of inputs")
        return
    }
    
    var output = ""
    for (index, value) in testValues.enumerate() {
        let outputLine: String
        if let result = countSheep(value) {
            outputLine = "Case #\(index + 1): \(result)"
        } else {
            outputLine = "Case #\(index + 1): INSOMNIA"
        }
        
        output = output + outputLine + "\n"
    }
    
    do {
        try output.writeToURL(outputFilePath, atomically: true, encoding: NSUTF8StringEncoding)
        print(output)
    } catch {
        print("Couldn't write to file")
    }
}

func countSheep(input: Int) -> Int? {
    guard input != 0 else { return nil }
    
    let intSet = Set(arrayLiteral: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
    var sheepSet = Set<Int>()
    var count = 0
    
    repeat {
        count += 1
        sheepSet = sheepSet.union(nextSheepSet(input * count))
    } while intSet != sheepSet
    
    return input * count
}

func nextSheepSet(var input: Int) -> Set<Int> {
    var sheetSet = Set<Int>()
    
    repeat {
        sheetSet.insert(input % 10)
        input /= 10
    } while input > 0
    
    return sheetSet
}

main()
