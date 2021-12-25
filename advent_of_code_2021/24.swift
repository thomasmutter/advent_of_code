//
//  24.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 24/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

struct SubmarineArithmeticLogicUnit {
    var x = 0
    var y = 0
    var z = 0
    var w = 0
    var input: String = ""
    let instructions = readInput(fileName: "2021_24")
    
    mutating func run(for input: String) {
        self.input = input
        for instruction in instructions {
            parseInstruction(instruction: instruction)
        }
        
        print("x = \(x)")
        print("y = \(y)")
        print("z = \(z)")
        print("w = \(w)") // the w just represents the input value at that point
    }
    
    mutating func findMaxModelNumber() {
        let instructionBlocks = readInput(fileName: "2021_24", separator: "inp w\n").filter { !$0.isEmpty }.map { $0.split(separator: "\n")
        }.map { instructions -> [String.SubSequence] in
            var instructionCopy = instructions
            instructionCopy.removeLast(2)
            instructionCopy.removeFirst(3)
            return Array(instructionCopy)
        }.map { $0.map { String($0) }}
        
        var stack = [(Int, Int)]()
        var modelNumber = [Int](repeating: 0, count: 14)
        
        for (index, block) in instructionBlocks.enumerated() {
            if block.first!.contains("1") {
                let yOffset = Int(block.last!.split(separator: " ").last!)!
                stack.insert((index, yOffset), at: 0)
            } else if block.first!.contains("26") {
                let xOffset = Int(block[1].split(separator: " ").last!)!
                let (previousIndex, yOffset) = stack.removeFirst()
                let totalOffset = yOffset + xOffset
                if totalOffset > 0 {
                    modelNumber[index] = 9
                    modelNumber[previousIndex] = 9 - totalOffset
                } else {
                    modelNumber[previousIndex] = 9
                    modelNumber[index] = 9 + totalOffset
                }
            }
        }
        
        print(modelNumber.map {String($0)}.joined())
    }
    
    mutating func findMinModelNumber() {
        let instructionBlocks = readInput(fileName: "2021_24", separator: "inp w\n").filter { !$0.isEmpty }.map { $0.split(separator: "\n")
        }.map { instructions -> [String.SubSequence] in
            var instructionCopy = instructions
            instructionCopy.removeLast(2)
            instructionCopy.removeFirst(3)
            return Array(instructionCopy)
        }.map { $0.map { String($0) }}
        
        var stack = [(Int, Int)]()
        var modelNumber = [Int](repeating: 0, count: 14)
        
        for (index, block) in instructionBlocks.enumerated() {
            if block.first!.contains("1") {
                let yOffset = Int(block.last!.split(separator: " ").last!)!
                stack.insert((index, yOffset), at: 0)
            } else if block.first!.contains("26") {
                let xOffset = Int(block[1].split(separator: " ").last!)!
                let (previousIndex, yOffset) = stack.removeFirst()
                let totalOffset = yOffset + xOffset
                if totalOffset > 0 {
                    modelNumber[previousIndex] = 1
                    modelNumber[index] = 1 + totalOffset
                } else {
                    modelNumber[index] = 1
                    modelNumber[previousIndex] = 1 - totalOffset
                }
            }
        }
        
        print(modelNumber.map {String($0)}.joined())
    }
    
    mutating func parseInstruction(instruction: String) {
       let parts = instruction.split(usingRegex: " ") + [""]
       let operation = parts[0]
       let storage = parts[1]
       let operand = parts[2]
       switch operation {
       case "inp":
           let value = input.removeFirst().wholeNumberValue!
           store(value, in: storage)
       case "add":
           let value = parseValue(value: storage) + parseValue(value: operand)
           store(value, in: storage)
       case "mul":
           let value = parseValue(value: storage) * parseValue(value: operand)
           store(value, in: storage)
       case "div":
           if parseValue(value: operand) == 0 {
               return
           }
           let value = parseValue(value: storage) / parseValue(value: operand)
           store(value, in: storage)
       case "mod":
           if parseValue(value: operand) <= 0 || parseValue(value: storage) < 0 {
               return
           }
           let value = parseValue(value: storage) % parseValue(value: operand)
           store(value, in: storage)
       case "eql":
           let value = parseValue(value: storage) == parseValue(value: operand)
           store(value ? 1 : 0, in: storage)
       default:
           fatalError("Invalid instruction encountered")
       }
    }
    
    mutating func store(_ value: Int, in storage: String) {
        switch storage {
        case "x":
            x = value
        case "y":
            y = value
        case "z":
            z = value
        case "w":
            w = value
        default:
            fatalError("Invalid storage location encountered")
        }
    }
    
    func parseValue(value: String) -> Int {
        switch value {
        case "x":
            return x
        case "y":
            return y
        case "z":
            return z
        case "w":
            return w
        default:
            return Int(value)!
        }
    }
    
}
