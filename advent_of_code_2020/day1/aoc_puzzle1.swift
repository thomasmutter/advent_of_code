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


func readFile(file: String) -> Array<Int> {
    var values = [Int]()
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        
        
        do {
            let text = try String(contentsOf: fileURL, encoding: .utf8)
            var textArray = text.components(separatedBy: "\n")
            textArray.removeLast()
            values = textArray.map {Int($0)!}
        }
        catch {
            print("Couldnt read file")
        }
    }
    return values
}



func find(max: Int, values: Array<Int>) -> Int {
    for value in values {
        if let x = values.first(where: { $0 == max - value && $0 + value <= max}) {
            return value * x
        }
    }
    return -1
}

func solve(values: Array<Int>) -> Int {
    for value in values {
        let max: Int = 2020 - value
        let y = find(max: max, values: values)
        if y != -1 {
            return y*value
        }
    }
    return -1
}
