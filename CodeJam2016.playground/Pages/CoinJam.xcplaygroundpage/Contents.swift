//: [Previous](@previous)

import Foundation
import XCPlayground

var str = "Hello, playground"

func toInts(value: String) -> Int {
    return Int(value) ?? 0
}

//Input
//
//1
//6 3

//Output
//
//Case #1:
//100011 5 13 147 31 43 1121 73 77 629
//111111 21 26 105 1302 217 1032 513 13286 10101
//111001 3 88 5 1938 7 208 3 20 11

//: [Next](@next)

func main() {
    let inputFileName = "C.in"
    let inputFilePath = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent(inputFileName)
    let outputFileName = "C.out"
    let outputFilePath = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent(outputFileName)
    let contents: String?
    
    do {
        contents = try String(contentsOfURL: inputFilePath)
    } catch {
        contents = nil
    }
    
    guard let input = Array(contents?.componentsSeparatedByString("\n").dropFirst() ?? []).first?.componentsSeparatedByString(" ").map(toInts)  else {
        print("Invalid Input")
        return
    }
    
    let length = input.first!
    let maxCount = input.last!
    
    let nonPrimeSet = getNonPrimeSet(300)
    let primeSet = Set(2...300).subtract(nonPrimeSet)
    
    var count = 0
    var output = "Case #1:\n"
    for i in (0..<pow(2, length-2)) {
        var divisors: [String] = []
        let paddedValue = onePaddedBinaryString(i, length: length)
        
        for j in (2...10) {
            let decimalValue = Int(strtoul("\(paddedValue)", nil, Int32(j)))
            
            guard let divisor = getDivisor(decimalValue, primeSet) else {
                break
            }
            
            divisors = divisors + ["\(divisor)"]
        }
        
        if divisors.count == 9 {
            output = output + "\(paddedValue) " + divisors.joinWithSeparator(" ") + "\n"
            count += 1
        }
        
        if count == maxCount {
            break
        }
    }
    
    output
    
    do {
        try output.writeToURL(outputFilePath, atomically: true, encoding: NSUTF8StringEncoding)
    } catch {
        print("Couldn't write to file")
    }
}

/**
Input: an integer n > 1

Let A be an array of Boolean values, indexed by integers 2 to n,
initially all set to true.

for i = 2, 3, 4, ..., not exceeding √n:
  if A[i] is true:
    for j = i^2, i^2+i, i^2+2i, i^2+3i, ..., not exceeding n :
      A[j] := false

Output: all i such that A[i] is true.
*/
func getNonPrimeSet(n: Int) -> Set<Int> {
    var nonPrimeSet = Set<Int>()
    
    let rootN = sqrt(n)
    var isPrimeList = [Bool](count: rootN, repeatedValue: true)
    for i in (2..<rootN) {
        if isPrimeList[i] {
            var nextValue: Int
            
            for j in 0..<rootN {
                let iSquared = pow(i, 2)
                nextValue = iSquared + i * j
                if nextValue >= rootN {
                    break
                }
                isPrimeList[nextValue] = false
                let nextSet = Set(arrayLiteral: nextValue)
                nonPrimeSet.unionInPlace(nextSet)
            }
        }
    }
    
    return nonPrimeSet
}

func getDivisor(value: Int, _ primeSet: Set<Int>) -> Int? {
    var divisor: Int? = nil

    value
    for i in Array(primeSet) {
        i
        if value % i == 0 {
            divisor = i
            break
        }
    }
    
    return divisor
}

func pad(string : String, toSize: Int) -> String {
    var padded = string
    for _ in 0..<toSize - string.characters.count {
        padded = "0" + padded
    }
    
    return "1" + padded + "1"
}

func onePaddedBinaryString(value: Int, length: Int) -> Int {
    let binaryValue = String(value, radix: 2)
    let paddedValue = pad(binaryValue, toSize: length - 2)
    return Int(paddedValue)!
}

func pow(input: Int, _ exp: Int) -> Int {
    return Int(pow(Double(input), Double(exp)))
}

func sqrt(input: String) -> Int {
    return Int(pow(Double(input)!, 0.5))
}

func sqrt(input: Int) -> Int {
    return Int(pow(Double(input), 0.5))
}

main()
