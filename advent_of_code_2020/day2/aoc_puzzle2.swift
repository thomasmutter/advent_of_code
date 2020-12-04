//
//  aoc_puzzle2.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 03/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

func decode(encoding: String) -> (Array<Int>, Character, String) {
    let passwordArray: Array<String> = encoding.components(separatedBy: " ")
    let boundaries: Array<Int> = passwordArray[0].components(separatedBy: "-").map { Int($0)! }
    let toMatch: Character = passwordArray[1].first!
    let password = passwordArray[2]
    
    return (boundaries, toMatch, password)
}

func validPassOld(boundaries: Array<Int>, toMatch: Character, password: String) -> Bool {
    let matchCount = password.filter { $0 == toMatch }.count
    return matchCount >= boundaries[0] && matchCount <= boundaries[1]
}

func validPassNew(boundaries: Array<Int>, toMatch: Character, password: String) -> Bool {
    let matchCount = (charAt(word: password, at: boundaries[0]-1) + charAt(word: password, at: boundaries[1]-1)).filter { $0 == toMatch }.count
    return matchCount == 1
}


func solveP2() {
    let passwords = readInput(fileName: "input_p2.txt")
    var oldCount = 0
    var newCount = 0
    for encoding in passwords {
        let (boundaries, toMatch, password) = decode(encoding: encoding)
        if validPassOld(boundaries: boundaries, toMatch: toMatch, password: password) {
            oldCount += 1
        }
        if validPassNew(boundaries: boundaries, toMatch: toMatch, password: password) {
            newCount += 1
        }
    }
    print(oldCount)
    print(newCount)
}
