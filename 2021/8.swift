//
//  8.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 08/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

func countEasyDigits() {
    let outputValues = readInput(fileName: "2021_8").map { $0.split(usingRegex: " \\| ")[1].split(separator: " ") }
    print(outputValues.map { $0.filter { $0.count != 5 && $0.count != 6 }.count }.reduce(0, +))
}

func addAllOutputDigits() {
    print(readInput(fileName: "2021_8").map { $0.split(usingRegex: " \\| ") }
        .map { entry in
            decode(outputValues: entry[1].split(usingRegex: " "), intEncoder: decodeNumbers(encodedNumbers: entry[0].split(usingRegex: " ")))
        }.reduce(0,+))

}

fileprivate func decodeNumbers(encodedNumbers: [String]) -> [Character: Int] {
    let sortedEncodedNumbers = encodedNumbers.sorted { $0.count < $1.count }
    var uniqueCharacters = reduceToUniqueCharacters(strings: sortedEncodedNumbers.filter { $0.count != 5 && $0.count != 6 })
    
    let one = sortedEncodedNumbers[0]
    let four = sortedEncodedNumbers[2]
    let twoThreeFive = sortedEncodedNumbers[3...5]
    let two = twoThreeFive.first { Set($0).union(four).count == 7 }!
    let three = twoThreeFive.first { Set($0).union(two).count == 6}!
    
    let segmentZero = Character(uniqueCharacters[1])
    let segmentTwo = Set(two).intersection(one).first!
    let (indexThree, segmentThree) = uniqueCharacters[2].enumerated().first { two.contains($1) }!
    uniqueCharacters[2].remove(at: uniqueCharacters[2].index(uniqueCharacters[2].startIndex, offsetBy: indexThree))
    let segmentOne = uniqueCharacters[2].first!
    let segmentFive = Set(one).subtracting(two).first!
    let (indexSix, segmentSix) = uniqueCharacters[3].enumerated().first { three.contains($1) }!
    uniqueCharacters[3].remove(at: uniqueCharacters[2].index(uniqueCharacters[2].startIndex, offsetBy: indexSix))
    let segmentFour = uniqueCharacters[3].first!
    
    // Encode segments in set of binary values in which each 1 represents a segment that is on and each 0 represents a segment that is off
    return [
        segmentTwo: 1 << 2,
        segmentFive: 1 << 5,
        segmentZero: 1 << 0,
        segmentOne: 1 << 1,
        segmentThree: 1 << 3,
        segmentFour: 1 << 4,
        segmentSix: 1 << 6
    ]
}

fileprivate func decode(outputValues: [String], intEncoder: [Character: Int]) -> Int {
    let decodeMap = [
        119: "0",
        36: "1",
        93: "2",
        109: "3",
        46: "4",
        107: "5",
        123: "6",
        37: "7",
        127: "8",
        111: "9"
    ]
    
    return Int(outputValues.map { $0.map { intEncoder[$0]! }.reduce(0,+) }.map { decodeMap[$0]!}.joined())!
}

fileprivate func reduceToUniqueCharacters(strings: [String]) -> [String] {
    let reduction: ([String], Set<Character>) = strings.reduce((acc: [], mask: Set<Character>())) { x, string in
        var (acc, mask) = x
        let filteredString = string.filter { !mask.contains($0) }
        acc.append(filteredString)
        mask = mask.union(filteredString)
        return (acc, mask)
    }
    
    return reduction.0.prefix { $0.count != 0 }
}
