//
//  18.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 19/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//



import Foundation

struct SnailFishNumberHomework {
    
    func largestMagnitude() -> Int {
        let numbers = readInput(fileName: "2021_18")
        var magnitudes = [Int]()
        
        for i in 0..<numbers.count {
            for j in i+1..<numbers.count {
                let n1 = numbers[i]
                let n2 = numbers[j]
                magnitudes.append(SnailFishNumber.build(number: add(n1, n2)).magnitude())
                magnitudes.append(SnailFishNumber.build(number: add(n2, n1)).magnitude())
            }
        }
        return magnitudes.max()!
    }
    
    func make() -> Int {
        let reducedTotalNumber = readInput(fileName: "2021_18").reduce1(add)
        return SnailFishNumber.build(number: reducedTotalNumber).magnitude()
    }
    
    func add(_ first: String, _ second: String) -> String {
        reduce(snailFishNumber: "[\(first),\(second)]")
    }
    
    func reduce(snailFishNumber: String) -> String {
        var reducedSnailFishNumber = explodeAll(snailFishNumber: snailFishNumber)
        var range = reducedSnailFishNumber.range(of: #"\d\d+"#, options: .regularExpression)
        while range != nil {
            let newPair = split(Int(reducedSnailFishNumber[range!])!)
            reducedSnailFishNumber.replaceSubrange(range!, with: newPair)
            reducedSnailFishNumber = explodeAll(snailFishNumber: reducedSnailFishNumber)
            range = reducedSnailFishNumber.range(of: #"\d\d+"#, options: .regularExpression)
        }
        
        return reducedSnailFishNumber
    }
    
    func explodeAll(snailFishNumber: String) -> String {
        var reducedSnailFishNumber = snailFishNumber
        var bracketCount = 0
        var stringPointer = reducedSnailFishNumber.startIndex
        
        while stringPointer != reducedSnailFishNumber.endIndex {
            let char = reducedSnailFishNumber[stringPointer]
            if char == "[" {
                bracketCount += 1
            }
            
            if char == "]" {
                bracketCount -= 1
            }
            
            if bracketCount > 4 {
                explode(pointer: &stringPointer, number: &reducedSnailFishNumber)
                bracketCount -= 1
            }
            stringPointer = reducedSnailFishNumber.index(stringPointer, offsetBy: 1)
        }
        return reducedSnailFishNumber
    }
    
    func explode(pointer: inout String.Index, number: inout String) {
        let pair = number[pointer...].split(separator: ",").map { String($0) }
        let (left, right) = (Int(String(String(pair[0].reversed()).prefix { $0.isWholeNumber }.reversed()))!, Int(pair[1].prefix { $0.isWholeNumber })!)
        let endOfPairPointer = number.index(pointer, offsetBy: 5 + left.step(at: 10) + right.step(at: 10))
        number.replaceSubrange(pointer..<endOfPairPointer, with: "0")

        if let range = number[number.index(after: pointer)...].range(of: #"\d+"#, options: .regularExpression) {
            let oldValue = Int(number[range])!
            let newValue = right + oldValue
            number.replaceSubrange(range, with: "\(newValue)")
        }
        
        var leftNumber = String(number[..<pointer].reversed())
        if let range = leftNumber.range(of: #"\d+"#, options: .regularExpression) {
            let oldValue = Int(String(leftNumber[range].reversed()))!
            let newValue = left + oldValue
            leftNumber.replaceSubrange(range, with: "\(newValue)".reversed())
            number.replaceSubrange(..<pointer, with: leftNumber.reversed())
        }
    }
    
    func split(_ value: Int) -> String {
        if value % 2 == 0 {
            return "[\(value >> 1),\(value >> 1)]"
        } else {
            return "[\(value >> 1),\(value >> 1 + 1)]"
        }
    }
    
}

enum SnailFishNumber {
    indirect case Pair(l: SnailFishNumber, r: SnailFishNumber)
    case Number(value: Int)
    
    func magnitude() -> Int {
        switch self {
        case .Pair(let left, let right):
            return 3*left.magnitude() + 2*right.magnitude()
        case .Number(let value):
            return value
        }
    }

    static func build(number: String) -> SnailFishNumber {
        let commaIndex = splitSnailFishNumber(number: number)
        var (left, right) = (number[...number.index(before: commaIndex)], number[number.index(after: commaIndex)...])
        
        left.removeFirst()
        right.removeLast()
        
        if let leftNumber = left.last?.wholeNumberValue, let rightNumber = right.first?.wholeNumberValue {
            return Pair(l: Number(value: leftNumber), r: Number(value: rightNumber))
        }
        
        if let leftNumber = left.last?.wholeNumberValue {
            return Pair(l: Number(value: leftNumber), r: build(number: String(right)))
        }
        
        if let rightNumber = right.first?.wholeNumberValue {
            return Pair(l: build(number: String(left)), r: Number(value: rightNumber))
        }
        
        return Pair(l: build(number: String(left)), r: build(number: String(right)))
    }
    
   private static func splitSnailFishNumber(number: String) -> String.Index {
        var numberWithoutExternalBrackets = number
        var openBracketCount = number.prefix { $0 == "[" }.count
        for _ in 0..<openBracketCount {
            numberWithoutExternalBrackets.removeFirst()
        }
        let closedBracketCount = number.reversed().prefix { $0 == "]" }.count
        for _ in 0..<closedBracketCount {
            numberWithoutExternalBrackets.removeLast()
        }
        var index = openBracketCount
        
        for char in numberWithoutExternalBrackets {
            if char == "[" {
                openBracketCount += 1
            }
            
            if char == "]" {
                openBracketCount -= 1
            }
            
            if char == "," && openBracketCount == 1 {
                break
            }
            
            index += 1
        }
        
        return number.index(number.startIndex, offsetBy: index)
    }
}
//
//extension String {
//    func findFirstRight(of index: String.Index, regex: String) -> String? {
//        if let range = self[index...].range(of: regex, options: .regularExpression) {
//            return String(self[range])
//        }
//        return nil
//    }
//
//    func findFirstLeft(of index: String.Index, regex: String) -> String? {
//        let reversed = String(self[..<index].reversed())
//        if let range = reversed.range(of: regex, options: .regularExpression) {
//            range.reversed
//            return String(reversed[range].reversed())
//        }
//        return nil
//    }
//}

extension Int {
    func step(at step: Int) -> Int {
        step > self ? 0 : 1
    }
}
