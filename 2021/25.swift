//
//  25.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 25/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

struct OceanTrenchSeaFloor {
    
    let oceanFloor: [String]
    let width: Int
    
    init() {
        width = readInput(fileName: "2021_25").first!.count
        oceanFloor = Array(readInput(fileName: "2021_25").map { $0.map { String($0) } }.joined())
    }
    
    func findLandingPosition() {
        var oceanFloorCopy = oceanFloor
        var moveCount = 0
        var stepCount = 0
        repeat {
            (oceanFloorCopy, moveCount) = move(">", on: oceanFloorCopy)
            let moveSouth = move("v", on: oceanFloorCopy)
            oceanFloorCopy = moveSouth.0
            moveCount += moveSouth.cucumbersMoved
            stepCount += 1
//            description(of: oceanFloorCopy)
        } while moveCount != 0
        
        print(stepCount)
    }
    
    func move(_ direction: String, on oceanFloor: [String]) -> ([String], cucumbersMoved: Int) {
        var oceanFloorCopy = oceanFloor
        var cucumbersMoved = 0
        for (position, facing) in oceanFloor.enumerated() {
            if facing == direction && direction == ">" {
                let newIndex = (position + 1) % width == 0 ? (position + 1) - width : position + 1
                
                if oceanFloor[newIndex] == "." {
                    oceanFloorCopy[position] = "."
                    oceanFloorCopy[newIndex] = ">"
                    cucumbersMoved += 1
                }
            }
            
            if facing == direction && direction == "v" {
                let newIndex = position + width >= oceanFloor.count ? (position + width) % width : position + width
                
                if oceanFloor[newIndex] == "." {
                    oceanFloorCopy[position] = "."
                    oceanFloorCopy[newIndex] = "v"
                    cucumbersMoved += 1
                }
            }
        }
        return (oceanFloorCopy, cucumbersMoved)
    }
    
    func description(of floor: [String]) {
        var d = ""
        for (index, char) in floor.enumerated() {
            if index % width == 0 {
                d += "\n"
            }
            d += String(char)
            
        }
        print(d)
    }
}
