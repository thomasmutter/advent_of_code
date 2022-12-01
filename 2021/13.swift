//
//  13.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 13/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

var transparentOrigamiPaper = TransparentOrigamiPaper(stringDescription: readInput(fileName: "2021_13", separator: "\n\n"))

struct TransparentOrigamiPaper {
    var marks: Set<Coordinate>
    let instructions: Array<FoldInstruction>
    private var width: Int
    private var height: Int
    
    init(stringDescription: [String]) {
        let markCoordinates = stringDescription[0].split(separator: "\n").map { String($0) }
        let instructions = stringDescription[1].split(separator: "\n").map { String($0) }
        
        marks = Set(markCoordinates.map { Coordinate(coordinate: $0) })
        self.instructions = instructions.map { FoldInstruction(instruction: $0) }
        width = marks.max { $0.x < $1.x }!.x
        height = marks.max { $0.y < $1.y }!.y
    }
    
    mutating func countDots(afterNumberOfInstructions instructionCount: Int) -> Int {
        for index in 0..<instructionCount {
            fold(by: instructions[index])
        }
        return marks.count
    }
    
    mutating func fold(by instruction: FoldInstruction) {
        switch instruction.direction {
        case .horizontal:
            marks = marks.filter { $0.y < instruction.line }.union(marks.filter { $0.y >= instruction.line }.map { $0.mirrored(along: .horizontal, on: instruction.line) })
            height -= instruction.line
        case .vertical:
            marks = marks.filter { $0.x < instruction.line }.union(marks.filter { $0.x >= instruction.line }.map { $0.mirrored(along: .vertical, on: instruction.line) })
            width -= instruction.line
        }
    }
    
    func drawDots() -> String {
        var paperRepresentation = ""
        for i in 0..<height {
            for j in 0..<width {
                if marks.contains(Coordinate(x: j, y: i)) {
                    paperRepresentation += "#"
                } else {
                    paperRepresentation += " "
                }
            }
            paperRepresentation += "\n"
        }
        return paperRepresentation
    }
    
    struct FoldInstruction {
        let direction: Direction
        let line: Int
        
        // Example instruction: fold along y=7
        init(instruction: String) {
            line = Int(instruction.split(separator: "=")[1])!
            let directionChar = instruction.split(separator: "=")[0].last!
            if directionChar == "x" {
                direction = .vertical
            } else {
                direction = .horizontal
            }
        }
    }
    
    struct Coordinate: Hashable, CustomStringConvertible {
        private(set) var x: Int
        private(set) var y: Int
        
        var description: String {
            "(x: \(x), y: \(y))"
        }
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        init(coordinate: String) {
            x = Int(coordinate.split(usingRegex: ",")[0])!
            y = Int(coordinate.split(usingRegex: ",")[1])!
        }
        
        func mirrored(along direction: Direction, on line: Int) -> Coordinate {
            switch direction {
            case .horizontal:
                // fold up
                return Coordinate(x: x, y: line - (y - line))
            case .vertical:
                // fold left
                return Coordinate(x: line - (x - line), y: y)
            }
        }
    }
    
    enum Direction {
        case horizontal
        case vertical
    }
}
