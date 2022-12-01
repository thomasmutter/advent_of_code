//
//  17.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 17/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation


struct TrickShotTrajectory {
    let trenchBottom = -100
    let trenchTop = -76
    let leftTrenchSide = 144
    let rightTrenchSide = 178
    
    // To find the maximum Y position, note that the trajectory always contains y = 0 twice
    // first on launch, secondly on descent. Therefore, the maximum possible velocity is the one
    // where the step after y = 0 is hit for the second time goes to the bottom of the trench at once
    // The amount of steps to reach the second y = 0 -> 2*velocity + 1
    func findMaximumYPosition() -> Int {
        let yVelocity = -1 - trenchBottom
        return (yVelocity * yVelocity + yVelocity) >> 1
    }

    func hasStepInTarget(with vx: Int, and vy: Int) -> Bool {
        let minYStep = computeStepBoundary(for: vy, boundary: trenchTop).rounded(.up)
        let maxYStep = computeStepBoundary(for: vy, boundary: trenchBottom).rounded(.down)
        
        let (x1, y1) = getCoordinates(for: vx, vy: vy, steps: Int(minYStep))
        let (x2, y2) = getCoordinates(for: vx, vy: vy, steps: Int(maxYStep))
        
        let containsX = x1 >= leftTrenchSide && x1 <= rightTrenchSide ||  x2 >= leftTrenchSide && x2 <= rightTrenchSide
        let containsY = y1 >= trenchBottom && y1 <= trenchTop || y2 >= trenchBottom && y2 <= trenchTop
        
        return containsX && containsY
    }
    
    func getCoordinates(for vx: Int, vy: Int, steps: Int) -> (x: Int, y: Int) {
        let xPosition = Int(steps) > vx ? Int(0.5*Double(vx)*(Double(vx) + 1)) : steps * Int(Double(vx)) - steps * (steps - 1) / 2
        let yPosition = steps * Int(Double(vy)) - steps * (steps - 1) / 2
        return (Int(xPosition), Int(yPosition))
    }
    
    func computeStepBoundary(for speed: Int, boundary: Int) -> Double {
        let a: Double = 2*Double(speed) + 1
        let s = sqrt(a*a - 8*(Double(boundary)))
        return (a + s)/2
    }
    
    func findNumberOfPossibleVelocities() -> Int {
        let maxVy = (-1 - trenchBottom)
        let minVx = 1
        var velocityCount = 0
        
        for vx in minVx...rightTrenchSide {
            for vy in trenchBottom...maxVy {
                if hasStepInTarget(with: vx, and: vy) {

                    velocityCount += 1
                }
            }
        }
        return velocityCount
    }
}
