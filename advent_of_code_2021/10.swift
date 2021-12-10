//
//  10.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 10/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

struct NavigationSubsystem {
    let lines = readInput(fileName: "2021_10")
    var totalSyntaxErrorScore: Int {
        lines.map { computeSyntaxErrorScore(in: $0) }.reduce(0,+)
    }
    var lineRepairScore: Int {
        let sortedScores = lines.map { computeRepairScore(in: $0) }.filter { $0 > 0 }.sorted()
        return sortedScores[sortedScores.count / 2]
    }
    
    private func computeRepairScore(in line: String) -> Int {
        var unmatchedBrackets = ""
        let scoringTable: [Character: Int] = [
            ")": 1,
            "]": 2,
            "}": 3,
            ">": 4
        ]
        
        for bracket in line {
            if "({[<".contains(bracket) {
                unmatchedBrackets.append(bracket)
            } else if unmatchedBrackets.last == getMatchingBracket(for: bracket) {
                let _ = unmatchedBrackets.popLast()
            } else {
                return 0
            }
        }
        
        return unmatchedBrackets.reversed().map { scoringTable[getMatchingBracket(for: $0)]! }.reduce(0) { 5*$0 + $1 }
    }
    
    private func computeSyntaxErrorScore(in line: String) -> Int {
        var unmatchedBrackets = [Character]()
        let scoringTable: [Character: Int] = [
            ")": 3,
            "]": 57,
            "}": 1197,
            ">": 25137
        ]
        
        for bracket in line {
            if "({[<".contains(bracket) {
                unmatchedBrackets.append(bracket)
            } else if unmatchedBrackets.last == getMatchingBracket(for: bracket) {
                let _ = unmatchedBrackets.popLast()
            } else {
                // Corrupt bracket found!
                return scoringTable[bracket]!
            }
        }
        return 0
    }
    
    private func getMatchingBracket(for bracket: Character) -> Character {
        switch bracket {
        case ")":
            return "("
        case "}":
            return "{"
        case "]":
            return "["
        case ">":
            return "<"
        case "(":
            return ")"
        case "{":
            return "}"
        case "[":
            return "]"
        case "<":
            return ">"
        default:
            fatalError("\(bracket) is not a valid character!") // should never happen
        }
    }
}



