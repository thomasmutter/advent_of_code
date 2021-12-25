//
//  15.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 15/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

var chitonCoveredCavern = ChitonCoveredCavern(riskLevels: readIntegerGrid(from: "File"))

struct ChitonCoveredCavern {
    let riskLevels: [Int]
    var distances: [Int:Int]
    
    private let width = 10
    
    init(riskLevels: [Int]) {
        var fullgrid = [Int](repeating: 0, count: riskLevels.count*25)
        for (index, value) in riskLevels.enumerated() {
            for i in 0 ..< 5 {
                fullgrid[width * 5 * (index / width) + i * width + index % width] = incrementOrWrap(value + i)
            }
        }
        
        for (index, value) in fullgrid[0..<width*5*width].enumerated() {
            for i in 0 ..< 5 {
                fullgrid[riskLevels.count * 5 * i + index] = incrementOrWrap(value + i)
            }
        }
        
        self.riskLevels = fullgrid
        self.distances = Dictionary(uniqueKeysWithValues: zip(0..<fullgrid.count, [Int](repeating: Int.max, count: fullgrid.count)))
        self.distances[0] = 0
    }
    
    // Dijkstra's algorithm
    mutating func findLowestRisk() -> Int {
        var sptSet = Set<Int>()
        var updatedVertices: Set<Int> = [0]
        
        while sptSet.count != riskLevels.count {
            let node = updatedVertices.map { ($0, distances[$0]!) }.min { $0.1 < $1.1 }!.0
            if node == riskLevels.count - 1 {
                break
            }
            sptSet.insert(node)
            updatedVertices.remove(node)
            for neighborIndex in riskLevels.getNeighborIndices(for: node, width: 50, with: .orthogonal) {
                updateDistance(for: neighborIndex, from: node)
                if !sptSet.contains(neighborIndex) {
                    updatedVertices.insert(neighborIndex)
                }
            }
        }
        return distances[riskLevels.count - 1]!
    }
    
    private mutating func updateDistance(for index: Int, from source: Int) {
        if distances[index]! > (distances[source]! + riskLevels[index]) {
            distances[index] = distances[source]! + riskLevels[index]
        }
    }
}
