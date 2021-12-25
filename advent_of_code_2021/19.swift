//
//  19.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 20/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation


struct BeaconScannerMapper {
    var scanners: [Scanner]
    
    init() {
        let scannerCoordinates = readInput(fileName: "2021_19" ,separator: "\n\n").map { Array($0.split(separator: "\n").map {String($0)}[1...]) }
        scanners = scannerCoordinates.map { Scanner(coordinates: $0) }
    }

    mutating func findLargestScannerDistance() {
        let absoluteCoordinates = scanners.map { $0.absolutePosition }
        var manhattanDistances = [Int]()
        for i in 0..<absoluteCoordinates.count {
            for j in i+1..<absoluteCoordinates.count {
                manhattanDistances.append(absoluteCoordinates[i].manhattanDistance(to: absoluteCoordinates[j]))
            }
        }
        print(manhattanDistances.max()!)
    }

    mutating func findUniqueBeacons() {
        computeScannerMappings()
        
        print(scanners.reduce(into: Set<Coordinate>()) { acc, scanner in
            acc = acc.union(scanner.transform())
        }.count)
    }
    
    private mutating func computeScannerMappings() {
        var mapped: Set<Int> = [0]
        var unmapped = Set(scanners[1...].indices)
        
        while !unmapped.isEmpty {
            var temp: Set<Int> = []
            for targetScannerIndex in mapped {
                for scannerIndex in unmapped {
                    if let coordinateRelation = scanners[scannerIndex].overlap(with: scanners[targetScannerIndex]) {
                        let map = findTransformation(withRelation: coordinateRelation)
                        scanners[scannerIndex].mapping = scanners[targetScannerIndex].mapping + [map]
                        temp.insert(scannerIndex)
                        unmapped.remove(scannerIndex)
                    }
                }
            }
            mapped.removeAll()
            mapped = temp
        }
    }
    

    func findTransformation(withRelation coordinatesRelation: [Coordinate: Coordinate]) -> (translation: Coordinate, rotation: (Coordinate) -> Coordinate) {
        let keys = Array(coordinatesRelation.keys)
        let firstCoordinate = keys[0]
        let secondCoordinate = keys[1]
        
        let delta = firstCoordinate - secondCoordinate
        let mappedFirstCoordinate = coordinatesRelation[firstCoordinate]!
        let mappedSecondCoordinate = coordinatesRelation[secondCoordinate]!
                                                        
        let rotation = delta.findTransformation(other: (mappedFirstCoordinate - mappedSecondCoordinate))
        let translation = firstCoordinate - rotation(mappedFirstCoordinate)
        return (translation, rotation)
    }
    
    
    struct Scanner {
        var beacons: [Coordinate]
        var mapping: [(Coordinate, (Coordinate) -> Coordinate)] = []
        var absolutePosition: Coordinate {
            if let lastMap = mapping.last {
                var scannerCoordinate = lastMap.0
                for map in mapping[..<(mapping.count - 1)].reversed() {
                    scannerCoordinate = map.1(scannerCoordinate) + map.0
                }
                return scannerCoordinate
            }
            return Coordinate(x: 0, y: 0, z: 0)
        }

        
        init(coordinates: [String]) {
            beacons = coordinates.map { Coordinate(stringRepresentation: $0) }
        }
        
        func computeBeaconDistances() -> [Int: (Int, Int)] {
            var distances = [Int: (Int, Int)]()
            for i in 0..<beacons.count {
                for j in i+1..<beacons.count {
                    let b1 = beacons[i]
                    let b2 = beacons[j]
                    let distance = (b1.x - b2.x) ^^ 2 + (b1.y - b2.y) ^^ 2 + (b1.z - b2.z) ^^ 2
                    distances[distance] = (i,j)
                }
            }
            return distances
        }
        
        func transform() -> [Coordinate] {
            var transformedCoordinates = beacons
            for transformation in mapping.reversed() {
                transformedCoordinates = transformedCoordinates.map { transformation.1($0) + transformation.0 }
            }
            return transformedCoordinates
        }
        
        func overlap(with scanner: Scanner) -> [Coordinate: Coordinate]? {
            let distanceMap = computeBeaconDistances()
            
            var overlapCount = 0
            var coordinatesRelation: [Coordinate: Coordinate] = [:]
            for i in 0..<scanner.beacons.count {
                overlapCount = 0
                coordinatesRelation.removeAll()
                var previousCoordinates: (Coordinate, Coordinate)? = nil
                for j in 0..<scanner.beacons.count {
                    if i == j { continue }
                    
                    let b1 = scanner.beacons[i]
                    let b2 = scanner.beacons[j]
                    let distance = (b1.x - b2.x) ^^ 2 + (b1.y - b2.y) ^^ 2 + (b1.z - b2.z) ^^ 2
                    
                    
                    if let match = distanceMap[distance] {
                        if let c = previousCoordinates {
                            coordinatesRelation[scanner.beacons[i]] = findCommonElement(in: c, and: (beacons[match.0], beacons[match.1]))
                        }
                        if let mappedCoordinate = coordinatesRelation[scanner.beacons[i]] {
                            if beacons[match.0] == mappedCoordinate {
                                coordinatesRelation[scanner.beacons[j]] = beacons[match.1]
                            } else {
                                coordinatesRelation[scanner.beacons[j]] = beacons[match.0]
                            }
                        }
                        overlapCount += 1
                        previousCoordinates = (beacons[match.0], beacons[match.1])
                    }
                    
                }
                if overlapCount >= 11 {
                    break
                }
                coordinatesRelation.removeAll()
            }
            
            if coordinatesRelation.isEmpty {
                return nil
            } else {
                return coordinatesRelation
            }
        }
        
        func findCommonElement(in tuple1: (Coordinate, Coordinate), and tuple2: (Coordinate, Coordinate)) -> Coordinate {
            if tuple1.0 == tuple2.0 || tuple1.0 == tuple2.1 {
                return tuple1.0
            } else {
                return tuple1.1
            }
        }
    }
        
    struct Coordinate: Hashable, Equatable, CustomStringConvertible {
        let x: Int
        let y: Int
        let z: Int
        var description: String {
            "(\(x), \(y), \(z))"
        }
        
        init(stringRepresentation: String) {
            let coordinates = stringRepresentation.split(usingRegex: ",")
            x = Int(coordinates[0])!
            y = Int(coordinates[1])!
            z = Int(coordinates[2])!
        }
        
        init(x: Int, y: Int, z: Int) {
            self.x = x
            self.y = y
            self.z = z
        }
        
        func findTransformation(other: Coordinate) -> (Coordinate) -> Coordinate {
            for rotation in Coordinate.rotations {
                if rotation(other) == self {
                    return rotation
                }
            }
            fatalError("Rotations must yield a match")
        }
        
        func manhattanDistance(to other: Coordinate) -> Int {
            abs(x - other.x) + abs(y - other.y) + abs(z - other.z)
        }
        
        static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
            return Coordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
        }
        
        static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
            return Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
        }
        
        static let rotations: [(Coordinate) -> Coordinate] = [
            { c in Coordinate(x: c.x, y: c.y, z: c.z) }, // Identity
            { c in Coordinate(x: c.x, y: -c.y, z: -c.z) },
            { c in Coordinate(x: -c.x, y: c.y, z: -c.z) },
            { c in Coordinate(x: -c.x, y: -c.y, z: c.z) },
            { c in Coordinate(x: c.x, y: c.z, z: -c.y) },
            { c in Coordinate(x: c.x, y: -c.z, z: c.y) },
            { c in Coordinate(x: -c.x, y: c.z, z: c.y) },
            { c in Coordinate(x: -c.x, y: -c.z, z: -c.y) },
            
            { c in Coordinate(x: c.y, y: c.z, z: c.x) },
            { c in Coordinate(x: c.y, y: -c.z, z: -c.x) },
            { c in Coordinate(x: -c.y, y: c.z, z: -c.x) },
            { c in Coordinate(x: -c.y, y: -c.z, z: c.x) },
            { c in Coordinate(x: c.y, y: c.x, z: -c.z) },
            { c in Coordinate(x: c.y, y: -c.x, z: c.z) },
            { c in Coordinate(x: -c.y, y: c.x, z: c.z) },
            { c in Coordinate(x: -c.y, y: -c.x, z: -c.z) },
            
            { c in Coordinate(x: c.z, y: c.x, z: c.y) },
            { c in Coordinate(x: c.z, y: -c.x, z: -c.y) },
            { c in Coordinate(x: -c.z, y: c.x, z: -c.y) },
            { c in Coordinate(x: -c.z, y: -c.x, z: c.y) },
            { c in Coordinate(x: c.z, y: c.y, z: -c.x) },
            { c in Coordinate(x: c.z, y: -c.y, z: c.x) },
            { c in Coordinate(x: -c.z, y: c.y, z: c.x) },
            { c in Coordinate(x: -c.z, y: -c.y, z: -c.x) },
        ]
    }
}

infix operator ^^: MultiplicationPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
