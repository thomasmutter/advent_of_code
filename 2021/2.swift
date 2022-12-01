//
//  2.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 02/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

func computePosition() -> Int {
    let course = readInput(fileName: "2021_2").map { split(command: $0) }
    var position = (horizontal: 0, depth: 0)
    for (instruction, displacement) in course {
        switch instruction {
        case "forward":
            position.horizontal += displacement
        case "down":
            position.depth += displacement
        case "up":
            position.depth -= displacement
        default:
            break
        }
    }
    return position.horizontal * position.depth
}

func computePositionWithAim() -> Int {
    let course = readInput(fileName: "2021_2").map { split(command: $0) }
    var position = (horizontal: 0, depth: 0, aim: 0)
    for (instruction, displacement) in course {
        switch instruction {
        case "forward":
            position.horizontal += displacement
            position.depth += (position.aim * displacement)
        case "down":
            position.aim += displacement
        case "up":
            position.aim -= displacement
        default:
            break
        }
    }
    return position.horizontal * position.depth
}

func split(command: String, seperator: Character = " ") -> (String, Int) {
    let splitCommand = command.split(separator: seperator)
    return (String(splitCommand[0]), Int(splitCommand[1]) ?? 0)
}
