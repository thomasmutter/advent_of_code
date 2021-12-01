//
//  1.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 01/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

let depthData = readInput(fileName: "2021_1").map { Int($0)! }

func countNumberOfDepthIncreases() -> Int {
    depthData.countWhile { $0 < $1 }
}

func countNumberOfSlidingWindowIncreases() -> Int {
    return depthData[..<(depthData.count - 2)].enumerated().map { index, dataPoint in depthData[index...(index + 2)].reduce(0, +) }.countWhile { $0 < $1 }
}

extension Array {
    func countWhile(_ predicate: (Element, Element) -> Bool) -> Int {
        var count = 0
        if var lastElement = self.first {
            for element in self[1...] {
                if predicate(lastElement, element) {
                    count += 1
                }
                lastElement = element
            }
        }
        return count
    }
}
