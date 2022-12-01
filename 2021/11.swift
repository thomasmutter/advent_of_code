//
//  11.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 11/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

var dumboOctopusHabitat = DumboOctopusHabitat(octopi: readInput(fileName: "2021_11")
                                                .joined()
                                                .map { DumboOctopusHabitat.DumboOctopus(energy: $0.wholeNumberValue!) })

struct DumboOctopusHabitat {
    var octopi: [DumboOctopus]
    let width = 10
    private(set) var stepsTaken = 0
    
    mutating func modelOctopiBehaviour(for steps: Int) -> Int {
        stepsTaken += steps
        return Array(0..<steps).map { _ in reset(); return step() }.reduce(0,+)
    }
    
    mutating func findFirstSynchronizedFlash() -> Int {
        var stepCounter: Int = stepsTaken
        while octopi.filter({ $0.hasFlashed }).count < octopi.count {
            reset()
            let _ = step()
            stepCounter += 1
        }
        return stepCounter
    }
    
    private mutating func step() -> Int {
        for index in 0..<octopi.count {
            octopi[index].incrementEnergy()
            if octopi[index].energy > 9 && !octopi[index].hasFlashed {
                flashCycle(around: index)
            }
        }
        
        let flashes = octopi.filter { $0.hasFlashed }.count
        return flashes
    }
    
    private mutating func flashCycle(around index: Int) {
        octopi[index].flash()
        
        for neighborIndex in neighborsForOctopus(at: index) {
            octopi[neighborIndex].incrementEnergy()
            if !octopi[neighborIndex].hasFlashed && octopi[neighborIndex].energy > 9 {
                flashCycle(around: neighborIndex)
            }
        }
    }
    
    private mutating func reset() {
        Array(0..<octopi.count).forEach { octopi[$0].reset() }
    }
    
    private func neighborsForOctopus(at index: Int) -> [Int] {
        var neighbors = [+1, -1, +width, -width, +width + 1, +width - 1, -width + 1, -width - 1]
            .map { $0 + index }.filter { $0 >= 0 && $0 < octopi.count }
        
        if index % width == 0 {
            neighbors = neighbors.filter { $0 % width != width - 1 }
        }
        
        if index % width == width - 1 {
            neighbors = neighbors.filter { $0 % width != 0 }
        }
        
        return neighbors
    }
    
    struct DumboOctopus {
        private(set) var energy: Int
        private(set) var hasFlashed: Bool = false
        
        mutating func incrementEnergy() {
            energy += 1
        }
        
        mutating func reset() {
            if hasFlashed {
                hasFlashed = false
                energy = 0
            }
        }
        
        mutating func flash() {
            hasFlashed = true
        }
    }
}
