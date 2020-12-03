//
//  aoc_puzzle3.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 03/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

let road = readFile(file: "input_p3.txt")
let length = road[0].count

let rightArray = [1, 3, 5, 7, 1]
let downArray = [1, 1, 1, 1, 2]

func findTrees(right: Int, down: Int) -> Int {
    var treeCount = 0
    for y in stride(from: 0, to: road.count, by: down) {
        let x = right*y/down % length
        if charAt(word: road[y], at: x) == "#" {
            treeCount += 1
        }
    }
    return treeCount
}

func solveP3() {
    var treeMulti = 1
    for i in 0...rightArray.count-1 {
        treeMulti *= findTrees(right: rightArray[i], down: downArray[i])
    }
    print(findTrees(right: 3, down: 1))
    print(treeMulti)
}
