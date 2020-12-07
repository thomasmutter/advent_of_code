//
//  aoc_puzzle5.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 05/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

let rows = 0..<128
let columnLength = 8
let seats = 0..<columnLength
let boardingPasses = readInput(fileName: "input_p5.txt")

func findLoc(pass: String, range: Range<Int>, spec: Character) -> Range<Int> {
    if range.count == 1 {
        return range
    }

    let halfRange = pass.first == spec ? range.prefix(range.count/2) : range.suffix(range.count/2)
    return findLoc(pass: String(pass.dropFirst()), range: halfRange, spec: spec)
}

func seatNo(pass: String) -> Int {
    let seatsCode = String(pass[pass.index(pass.startIndex, offsetBy: Int(log2(Double(rows.last!+1))))...])
    let rowNo = findLoc(pass: pass, range: rows, spec: "F").first!
    let colNo = findLoc(pass: seatsCode, range: seats, spec: "L").first!
    return rowNo * columnLength + colNo
}

func findSeat(seats: Array<Int>) -> Array<Int> {
    if seats.count == 1 {
        return seats
    }
    let middle: Int = seats.count/2
    return seats[middle] == seats[...middle].count ? Array<Int>(seats[..<middle]) : Array<Int>(seats[middle...])
}

func solveP5() {
    var seatNos = boardingPasses.map{ pass in seatNo(pass: pass) }
    print(seatNos.max()!)
    seatNos.sort()
    var oldNo = 0
    for number in seatNos {
        if number - oldNo == 2 {
            print(number-1)
        }
        oldNo = number
    }
}
