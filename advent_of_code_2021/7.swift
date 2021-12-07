//
//  7.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 07/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

let constantFuelComputation: (Int) -> Int = { distance in distance }
let incrementingFuelComputation: (Int) -> Int = { distance in (distance * (distance + 1)) >> 1}

func bruteForceFuelMinimalization(for fuelComputation: (Int) -> Int) {
    var positionCount: [Int:Int] = [:]
    readInput(fileName: "2021_7").first!.split(separator: ",").map { Int($0)! }.forEach {
        if let count = positionCount[$0] {
            positionCount[$0] = count + 1
        } else {
            positionCount[$0] = 1
        }
    }
    
    let minPosition = positionCount.keys.min()!
    let maxPosition = positionCount.keys.max()!
    
    var minimumFuelUsage: Int = Int.max
    for sharedPosition in minPosition...maxPosition {
        let fuelUsage = positionCount.map { position, amount in
            amount * fuelComputation(abs(position - sharedPosition))
        }.reduce(0, +)
        if fuelUsage < minimumFuelUsage {
            minimumFuelUsage = fuelUsage
        }
    }
    
    print(minimumFuelUsage)
}
