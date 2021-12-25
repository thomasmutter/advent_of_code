//
//  14.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 14/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

let extendedPolymerizationInput = readInput(fileName: "2021_14", separator: "\n\n")
let extendedPolymerization = ExtendedPolymerization(template: extendedPolymerizationInput[0], pairInsertionRules: extendedPolymerizationInput[1].split(usingRegex: "\n"))

struct ExtendedPolymerization {
    let template: String
    let pairInsertionRules: [String: Character]
    
    init(template: String, pairInsertionRules: [String]) {
        self.template = template
        self.pairInsertionRules = pairInsertionRules.reduce(into: [String: Character]()) { acc, rule in
            let (pair, insertion) = (rule.split(usingRegex: " -> ")[0], rule.split(usingRegex: " -> ")[1])
            acc.updateValue(insertion.first!, forKey: pair)
        }
    }
    
    // -- MARK: Brute force
    func computeCommonCharacterDifferenceBruteForce(overIterations: Int) -> Int {
        let polymer = growPolymer(overIterations: overIterations)
        return polymer.mostCommonCharacterCount() - polymer.leastCommonCharacterCount()
    }
    
    func growPolymer(overIterations: Int) -> String {
        var currentPolymer = template
        for _ in 0..<overIterations {
            currentPolymer = polymerize(template: currentPolymer)
        }
        return currentPolymer
    }
    
    private func polymerize(template: String) -> String {
        // check string pair by pair and do inserts
        var polymer = ""
        for index in 0..<(template.count - 1) {
            let pair = template.substring(from: index, to: index + 2)
            let element = pairInsertionRules[pair]!
            polymer += pair.first!.add(element)
        }
        polymer.append(template.last!)
        return polymer
    }
    
    // -- MARK: Pair counting
    func computeCommonCharacterDifference(overIterations: Int) -> Int {
        let pairCount = countPairs(overIterations: overIterations)
        var characterCounts = pairCount.reduce(into: [Character: Int]()) { acc, pairCount in
            let pair = pairCount.key
            let count = pairCount.value
            acc.insertOrAdd(count, forKey: pair.first!)
            acc.insertOrAdd(count, forKey: pair.last!)
        }
            
        // Take into account double counting (Add extra first and last character, to have everything doubly counted)
        characterCounts.insertOrIncrement(template.first!)
        characterCounts.insertOrIncrement(template.last!)
        let sortedCounts = characterCounts.sorted { $0.value > $1.value }.map { $0.value >> 1}
        return sortedCounts.first! - sortedCounts.last!
    }
    
    func countPairs(overIterations: Int) -> [String: Int] {
        var pairCount = [String: Int]()
        for index in 0..<(template.count - 1) {
            let pair = template.substring(from: index, to: index + 2)
            pairCount.insertOrIncrement(pair)
        }
        
        for _ in 0..<overIterations {
            pairCount = countPairs(pairCount)
        }
        return pairCount
    }
    
    func countPairs(_ oldPairCount: [String: Int]) -> [String: Int] {
        var newPairCount = [String:Int]()
        for (pair, count) in oldPairCount {
            let element = pairInsertionRules[pair]!
            let (leftPair, rightPair) = (pair.first!.add(element), element.add(pair.last!))
            newPairCount.insertOrAdd(count, forKey: leftPair)
            newPairCount.insertOrAdd(count, forKey: rightPair)
        }
        return newPairCount
    }
}
