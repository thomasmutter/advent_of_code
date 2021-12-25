//
//  12.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 12/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

let caveSystem = CaveSystem(connections: readInput(fileName: "2021_12"))

struct CaveSystem {
//    let start: Cave
//    let end: Cave
    let connections: [String: [String]]
    
    init(connections: [String]) {
        var connectionMap = [String: [String]]()
        for connection in connections {
            let connectedCaves = connection.split(usingRegex: "-")
            let (x, y) = (connectedCaves[0], connectedCaves[1])
            
            connectionMap[x] = (connectionMap[x] ?? []) + [y]
            connectionMap[y] = (connectionMap[y] ?? []) + [x]
        }
        
        self.connections = connectionMap
    }
    
    
//    func findAllDistinctPathCount(from cave: String, with visited: Set<String> = ["start"]) -> Int {
//        if cave == "end" {
//            return 1
//        }
//
//        var count = 0
//        for neighborCave in connections[cave]! {
//            if !visited.contains(neighborCave) {
//                var newVisited = visited
//                if neighborCave.allLowerCase() {
//                    newVisited.insert(neighborCave)
//                }
//                count += findAllDistinctPathCount(from: neighborCave, with: newVisited)
//            }
//        }
//
//        return count
//    }
    
    func findAllDistinctPathCount(from cave: String, with visited: [String: Int] = [:], path: String = "") -> Int {
        if cave == "end" {
//            print("\(path.substring(from: path.index(path.startIndex, offsetBy: 2))), end")
            return 1
        }
        
        var path2 = "\(path), \(cave)"
        var count = 0
        for neighborCave in connections[cave]! {
            // the check here is -> one small cave can do 2 times
            
            // If there is a small cave that was visited twice check: if this is the small cave
            
            let bool1 = visited.values.contains(2) && visited[neighborCave] == nil
            let bool2 = visited.values.contains(2) && visited[cave] == 2 && visited[neighborCave] == nil
            let bool3 = !visited.values.contains(2)
            
            if neighborCave != "start" && (bool3 || (bool1 || bool2)) {
                var newVisited = visited
                if neighborCave.allLowerCase() {
                    newVisited[neighborCave] = (newVisited[neighborCave] ?? 0) + 1
                }
                count += findAllDistinctPathCount(from: neighborCave, with: newVisited, path: path2)
            }
        }
        
        return count
    }

    
//    struct Cave {
//        let neighbors: [Cave]
//        let size: Size
//        let value: String
//
//        enum Size {
//            case large
//            case small
//        }
//    }
}
