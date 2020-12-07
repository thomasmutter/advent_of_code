//
//  aoc_puzzle6.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 07/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

let answers = readInput(fileName: "input_p6.txt", separator: "\n\n")

func findCommonCharacters(text: String) -> Int {
    let a = text.split(separator: "\n").map{ String($0) }
    return a.reduce(a[0], { x, y in String(Set(x).intersection(Set(y)))}).count
}

func solveP6() {
    print(answers.map { ps in ps.replacingOccurrences(of: "\n", with:"")}.map{ Set($0).count }.reduce(0, {x, y in x + y}))
    print(answers.map{ findCommonCharacters(text: $0)}.reduce(0, {x, y in x + y}))
}
