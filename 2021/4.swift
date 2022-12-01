//
//  4.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 04/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation


let input = readInput(fileName: "2021_4", separator: "\n\n")

var bingoNumbers: [Int] = input.first?.split(separator: ",").map { Int($0)! } ?? []
var boards: [Board] =
    input[1...].map { $0.trimmingCharacters(in: .whitespacesAndNewlines).split(usingRegex: "\\s+") }.map { $0.map { Int($0)! } }.map { Board(values: $0) }

func playBingo() {
    var bingoNumber: Int = 0
    while boards.first(where: { $0.hasBingo }) == nil {
        bingoNumber = bingoNumbers.removeFirst()
        for i in 0..<boards.count {
            boards[i].updateBoard(with: bingoNumber)
        }
    }
    print(boards.first { $0.hasBingo }!.sumOfUnmarkedFieldValues() * bingoNumber)
}

func letSquidWin() {
    var bingoNumber: Int = 0
    
    // Play bingo on all boards
    while boards.count != 1 {
        bingoNumber = bingoNumbers.removeFirst()
        for i in 0..<boards.count {
            boards[i].updateBoard(with: bingoNumber)
        }
        boards = boards.filter { !$0.hasBingo }
    }
    
    // Play bingo on last board
    var lastBoard = boards.first!
    while !lastBoard.hasBingo {
        bingoNumber = bingoNumbers.removeFirst()
        lastBoard.updateBoard(with: bingoNumber)
    }
    print(lastBoard.sumOfUnmarkedFieldValues() * bingoNumber)
}


struct Board {
    var fields: Array<Field>
    private(set) var hasBingo: Bool = false
    
    init(values: [Int]) {
        self.fields = values.map { Field(value: $0) }
    }
    
    mutating func updateBoard(with value: Int) {
        if let fieldIndex = findIndexOfField(with: value) {
            fields[fieldIndex].mark()
            checkForBingo(around: fieldIndex)
        }
    }
    
    func sumOfUnmarkedFieldValues() -> Int {
        fields.filter { !$0.marked }.map { $0.value }.reduce(0, +)
    }
    
    private func findIndexOfField(with value: Int) -> Int? {
        fields.enumerated().first { $1.value == value }?.0
    }
    
    mutating private func checkForBingo(around index: Int) {
        let boardDimension = Int(Double(fields.count).squareRoot())
        let (rowNumber, colNumber) = index.quotientAndRemainder(dividingBy: boardDimension)
        
        // check bingo for row
        let rowStartIndex = rowNumber * boardDimension
        let row = fields[rowStartIndex..<(rowStartIndex + boardDimension)]
        if row.prefix(while: { $0.marked }).count == boardDimension {
            self.hasBingo = true
            return
        }
        
        // check bingo for column
        var col = [Field]()
        for ite in 0..<boardDimension {
            col.append(fields[ite * boardDimension + colNumber])
        }
        if col.prefix(while: { $0.marked }).count == boardDimension {
            self.hasBingo = true
            return
        }
    }
    
    struct Field {
        let value: Int
        private(set) var marked: Bool = false
        
        mutating func mark() {
            marked = true
        }
    }
}
