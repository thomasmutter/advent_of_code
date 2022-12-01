//
//  5.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 05/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

let hydrothermalVentCoordinates = readInput(fileName: "2021_5")

func countOverlappingHorizontalAndVerticalLines() {
    var grid = VentLineGrid(includeDiagonalLines: false)
    hydrothermalVentCoordinates.map { line in
        line.split(usingRegex: " -> ").map { $0.split(separator: ",") }.map { VentLineGrid.GridPoint(x: Int($0[0])!, y: Int($0[1])!)}
    }.forEach {
        grid.addLine(from: $0[0], to: $0[1])
    }
    print(grid.countOverlaps())
}

func countAllOverlappingLines() {
    var grid = VentLineGrid(includeDiagonalLines: true)
    hydrothermalVentCoordinates.map { line in
        line.split(usingRegex: " -> ").map { $0.split(separator: ",") }.map { VentLineGrid.GridPoint(x: Int($0[0])!, y: Int($0[1])!)}
    }.forEach {
        grid.addLine(from: $0[0], to: $0[1])
    }
    print(grid.countOverlaps())
}

struct VentLineGrid {
    var coordinates: [GridPoint: Int] = [:]
    let includeDiagonalLines: Bool
    
    func countOverlaps() -> Int {
        coordinates.values.filter { $0 >= 2 }.count
    }
    
    mutating func addLine(from startCoordinate: GridPoint, to endCoordinate: GridPoint) {
        let x1 = startCoordinate.x
        let y1 = startCoordinate.y
        
        switch (endCoordinate.x, endCoordinate.y) {
        case let (x2, y2) where x1 == x2:
            // draw vertical line
            for y in min(y1, y2)...max(y1, y2) {
                let gridPoint = GridPoint(x: x2, y: y)
                updateCoordinates(for: gridPoint)
            }
        case let (x2, y2) where y1 == y2:
            // draw horizontal line
            for x in min(x1, x2)...max(x1, x2) {
                let gridPoint = GridPoint(x: x, y: y2)
                updateCoordinates(for: gridPoint)
            }
        case let (x2, y2) where includeDiagonalLines:
            // draw diagonal line
            var xSign = 1
            var ySign = 1
            
            if x1 > x2 {
                xSign = -1
            }
            if y1 > y2 {
                ySign = -1
            }
            
            var tempCoordinate = (x1, y1)
            for _ in min(x1, x2)...max(x1, x2) {
                let gridPoint = GridPoint(x: tempCoordinate.0, y: tempCoordinate.1)
                updateCoordinates(for: gridPoint)
                tempCoordinate.0 += xSign
                tempCoordinate.1 += ySign
            }
        default:
            break
        }
    }
    
    mutating func updateCoordinates(for gridPoint: GridPoint) {
        if let numberOfLines = coordinates[gridPoint] {
            coordinates[gridPoint] = numberOfLines + 1
        } else {
            coordinates[gridPoint] = 1
        }
    }
    
    struct GridPoint: Hashable {
        let x: Int
        let y: Int
    }
}
