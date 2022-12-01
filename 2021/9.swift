//
//  9.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 09/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

let lavaTubeTextRepresentation = readInput(fileName: "2021_9")
let lavaTubeSystem = LavaTubeSystem(points: lavaTubeTextRepresentation.joined().map { $0.wholeNumberValue! }, width: lavaTubeTextRepresentation.first!.count)

struct LavaTubeSystem {
    var points: [Int]
    let width: Int
    
    func computeRiskLevel() -> Int {
        points.enumerated().filter { isLowest($0.0) }.map { 1 + $0.1 }.reduce(0,+)
    }
    
    func findThreeLargestBasins() -> [Int] {
        Array(
            points
                .enumerated()
                .filter { isLowest($0.0) }
                .reduce([Int]()) { acc, lpi in
                    var basin = Set<Int>()
                    formBasin(lpi.0, in: &basin)
                    return acc + [basin.count]
                }
                .sorted(by: >)[0..<3]
        )
    }
    
    private func formBasin(_ point: Int, in basin: inout Set<Int>) {
        // Mark point as visited
        basin.insert(point)
        
        for neighbor in getNeighborCoordinates(for: point) {
            if !basin.contains(neighbor) && points[neighbor] != 9 {
                formBasin(neighbor, in: &basin)
            }
        }
    }
    
    private func isLowest(_ point: Int) -> Bool {
        getNeighborCoordinates(for: point).first { points[point] >= points[$0] } == nil
    }
    
    private func getNeighborCoordinates(for point: Int) -> [Int] {
        var neighbors = [Int]()
        
        if point >= points.count {
            return []
        }
        
        if point + width < points.count {
            neighbors.append(point + width)
        }
        
        if point - width >= 0 {
            neighbors.append(point - width)
        }
        
        if (point + 1) % width != 0 && point + 1 < points.count {
            neighbors.append(point + 1)
        }
        
        if (point - 1) % width != width - 1 && point - 1 >= 0 {
            neighbors.append(point - 1)
        }
        
        return neighbors
    }
}
