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
        lines.map { computeRepairScore(in: $0) }.filter { $0 > 0 }.sorted().middle
    }
    
    private func computeRepairScore(in line: String) -> Int {
        var unmatchedBrackets = Stack<Character>()
        let scoringTable: [Character: Int] = [
            ")": 1,
            "]": 2,
            "}": 3,
            ">": 4
        ]
        
        for bracket in line {
            if "({[<".contains(bracket) {
                unmatchedBrackets.push(bracket)
            } else if unmatchedBrackets.peek() == getMatchingBracket(for: bracket) {
                let _ = unmatchedBrackets.pop()
            } else {
                return 0
            }
        }
        
        var score = 0
        while let bracket = unmatchedBrackets.pop() {
            score = 5 * score + scoringTable[getMatchingBracket(for: bracket)]!
        }
        
        return score
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


extension Array {
    var middle: Element {
        self[self.count / 2]
    }
}

struct Stack<Element> {
    private var head: Node<Element>?
    
    mutating func push(_ element: Element) {
        let newNode = Node(next: head, value: element)
        head = newNode
    }
    
    mutating func pop() -> Element? {
        let element = head?.value
        head = head?.next
        return element
    }
    
    func peek() -> Element? {
        head?.value
    }

    private class Node<Element> {
        var value: Element
        var next: Node?
        
        init(next: Node?, value: Element) {
            self.next = next
            self.value = value
        }
    }
}
