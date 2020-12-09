//
//  aoc_puzzle9.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 09/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

let numbers = readInput(fileName: "input_p9.txt").map{ Int($0)! }
let preambleSize = 25

func hasSum(previous: Array<Int>, current: Int) -> Bool {
    var summables = Set<Int>()
    for i in 0..<previous.count {
        if summables.contains(current - previous[i]) {
            return true
        }
        summables.insert(previous[i])
    }
    return false
}

func findContagiousSum(result: Int) -> Int {
    var sum = 0
    var lowerBound = 0
    var upperBound = 0
    var iterator = numbers.makeIterator()
    while let next = iterator.next() {
        sum += next
        if sum > result{
            while sum > result {
                sum -= numbers[lowerBound]
                lowerBound += 1
            }
        }
        if sum == result {
            break
        }
        upperBound += 1
    }
    
    let contagiousRange = Array(numbers[lowerBound...upperBound])
    return contagiousRange.min()! + contagiousRange.max()!
}

func solveP9() {
    let result = numbers[preambleSize...].enumerated().first{ !hasSum(previous: Array<Int>(numbers[$0.0..<$0.0+preambleSize]), current: $0.1) }!.1
    print(result)
    print(findContagiousSum(result: result))
}
