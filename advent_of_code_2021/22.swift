//
//  22.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 22/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

struct SubmarineReactorRebooter {
    let rebootInstructions: [RebootInstruction]
    var onCuboids = [Cuboid]()
    var offCuboids = [Cuboid]()
    
    init() {
        let instructions = readInput(fileName: "2021_22")
        rebootInstructions = instructions.map { RebootInstruction(instruction: $0) }
    }
    
    mutating func reboot() {
        // Perhaps performance can be improved by using a set to avoid duplicated cuboids
        for instruction in rebootInstructions {
            var temp = [Cuboid]()
            for cuboid in onCuboids {
                
                // Find all overlapping cubes the new cuboid has with any cuboids in the onCuboids section
                // If instruction is on: overlap with any cuboid means that cuboid will be counted on 1 time extra per overlap
                // so this overlap is added to the offCuboids to correct for extra counting
                // If instruction is off: looking for cuboids that should be turned off, that is exactly the overlap
                if let overlappingCuboid = cuboid.overlap(with: instruction.cuboid) {
                    temp.append(overlappingCuboid)
                }
            }
            
            for cuboid in offCuboids {
                
                // Find all overlapping cubes the new cuboid has with any cuboids in the offCuboids section
                // If instruction is off: overlap with any cuboid means that cuboid will be counted off 1 time extra per overlap
                // so this overlap is added to the offCuboids to correct for extra counting
                // If instruction is on: looking for cuboids that should be turned off, that is exactly the overlap
                if let overlappingCuboid = cuboid.overlap(with: instruction.cuboid) {
                    onCuboids.append(overlappingCuboid)
                }
            }
            
            offCuboids.append(contentsOf: temp)
            if instruction.turnOn {
                onCuboids.append(instruction.cuboid)
            }
        }
        print(onCuboids.count)
        print(offCuboids.count)
        print(onCuboids.reduce(0) { acc, x in acc + x.volume } - offCuboids.reduce(0) { acc, x in acc + x.volume })
    }
    
    struct RebootInstruction {
        let cuboid: Cuboid
        let turnOn: Bool
        
        init(instruction: String) {
            turnOn = instruction.contains("on")
            let instructionRange = NSRange(instruction.startIndex..<instruction.endIndex, in: instruction)
            let regex = try! NSRegularExpression(pattern: #"-?\d+"#, options: [])
            let matches = regex.matches(in: instruction, options: [], range: instructionRange)
            
            var rangeNumbers = [Int]()
            for match in matches {
                for rangeIndex in 0..<match.numberOfRanges {
                    let matchRange = match.range(at: rangeIndex)
                    
                    if matchRange == instructionRange { continue }
                    
                    if let numberRange = Range(matchRange, in: instruction) {
                        let number = String(instruction[numberRange])
                        rangeNumbers.append(Int(number)!)
                    }
                }
            }
            
            let xRange = Cuboid.CoordinateRange(start: rangeNumbers[0], end: rangeNumbers[1])
            let yRange = Cuboid.CoordinateRange(start: rangeNumbers[2], end: rangeNumbers[3])
            let zRange = Cuboid.CoordinateRange(start: rangeNumbers[4], end: rangeNumbers[5])
            
            cuboid = Cuboid(xRange: xRange, yRange: yRange, zRange: zRange)
        }
    }
    
    struct Cuboid: CustomStringConvertible, Hashable {
        let xRange: CoordinateRange
        let yRange: CoordinateRange
        let zRange: CoordinateRange
        
        var description: String {
            "x=\(xRange.start)..\(xRange.end), y=\(yRange.start)..\(yRange.end), z=\(zRange.start)..\(zRange.end)"
        }
        
        var volume: Int {
            (xRange.end - xRange.start + 1) * (yRange.end - yRange.start + 1) * (zRange.end - zRange.start + 1)
        }
        
        func overlap(with other: Cuboid) -> Cuboid? {
            let xOverlap = xRange.overlap(with: other.xRange)
            let yOverlap = yRange.overlap(with: other.yRange)
            let zOverlap = zRange.overlap(with: other.zRange)
            
            if let xr = xOverlap, let yr = yOverlap, let zr = zOverlap {
                return Cuboid(xRange: xr, yRange: yr, zRange: zr)
            }
            return nil
        }
        
        struct CoordinateRange: Hashable {
            let start: Int
            let end: Int
            
            func overlap(with other: CoordinateRange) -> CoordinateRange? {
                if other.start < start && other.end > end {
                    return self
                }
                
                if other.start >= start && other.end <= end {
                    return other
                }
                
                if other.start >= start && other.start <= end && other.end > end {
                    return CoordinateRange(start: other.start, end: end)
                }
                
                if other.start < start && other.end >= start && other.end <= end {
                    return CoordinateRange(start: start, end: other.end)
                }
                
                return nil
            }
        }
    }
}
