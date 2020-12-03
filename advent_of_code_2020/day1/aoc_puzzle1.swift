//
//  aoc_puzzle1.swift
//  advent_of_code_2020
//
//  Created by Thomas Mutter on 03/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

let file = "input_p1.txt"
let year = 2020

func find(max: Int, values: Array<Int>) -> Int {
    for value in values {
        if let x = values.first(where: { $0 == max - value && $0 + value <= max}) {
            return value * x
        }
    }
    return -1
}

func solveP1() -> Int {
    let values = readFile(file: file).map {Int($0)!}
    for value in values {
        let max: Int = 2020 - value
        let y = find(max: max, values: values)
        if y != -1 {
            return y*value
        }
    }
    return -1
}
