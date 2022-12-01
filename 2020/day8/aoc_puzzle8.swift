//
//  aoc_puzzle8.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 08/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

var bootCode: [(String, Int, Int)] = readInput(fileName: "input_p8.txt").reduce(into: []) {
    let x = $1.components(separatedBy: " ")
    $0.append((x[0], Int(x[1])!, 0))
}

let cmdSwap = ["jmp":"nop", "nop":"jmp"]

func runCode() -> (Int, Int) {
    var next = bootCode[0]
    var pointer = 0
    var accumulator = 0
    while (next.2 == 0 && pointer < bootCode.count) {
        next = bootCode[pointer]
        bootCode[pointer].2 = 1
        if next.0 == "jmp" {
            pointer += next.1
        } else {
            pointer += 1
            accumulator += next.0 == "acc" ? next.1 : 0
        }
    }
    return (accumulator, pointer)
}

func resetBootCode() {
    bootCode = bootCode.map { ($0.0, $0.1, 0) }
}

func fixCode() {
    for (idx, ins) in bootCode.enumerated() {
        if ins.0 == "acc" {
            continue
        }
        bootCode[idx].0 = cmdSwap[ins.0]!
        let result = runCode()
        if result.1 == bootCode.count {
            print(result.0)
            break
        }
        bootCode[idx].0 = cmdSwap[bootCode[idx].0]!
        resetBootCode()
    }
}

func solveP8() {
    print(fixCode())
}
