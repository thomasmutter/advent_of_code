//
//  23.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 23/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

// Didnt manage to write a program to solve it, solved it by hand

struct AmphipodBurrow: CustomStringConvertible {
    var hallway = Hallway()
    var sideRooms: (amberRoom: SideRoom, bronzeRoom: SideRoom, copperRoom: SideRoom, desertRoom: SideRoom)
    
    var description: String {
        var description = "#############\n"
        description += "#\(hallway)#\n"
        for i in 0..<sideRooms.0.amphipods.count {
            if i == 0 {
                description += "###\(sideRooms.0.amphipods[i])#\(sideRooms.1.amphipods[i])#\(sideRooms.2.amphipods[i])#\(sideRooms.3.amphipods[i])###\n"
            } else {
                description += "  #\(sideRooms.0.amphipods[i])#\(sideRooms.1.amphipods[i])#\(sideRooms.2.amphipods[i])#\(sideRooms.3.amphipods[i])#\n"
            }
        }
        description += "  #########"
        return description
    }
    
    init() {
        let diagram = readInput(fileName: "File", separator: "\n\n").first!
        let diagramRange = NSRange(diagram.startIndex..<diagram.endIndex, in: diagram)
        let regex = try! NSRegularExpression(pattern: #"[A-D]"#, options: [])
        let matches = regex.matches(in: diagram, options: [], range: diagramRange)
        
        var amphipods = [String]()
        for match in matches {
            for rangeIndex in 0..<match.numberOfRanges {
                let matchRange = match.range(at: rangeIndex)
                
                if matchRange == diagramRange { continue }
                
                if let numberRange = Range(matchRange, in: diagram) {
                    let amphipod = String(diagram[numberRange])
                    amphipods.append(amphipod)
                }
            }
        }
        
        var AmberSideRoom = SideRoom(amphipods: [], type: .amber)
        var BronzeSideRoom = SideRoom(amphipods: [], type: .bronze)
        var CopperSideRoom = SideRoom(amphipods: [], type: .copper)
        var DesertSideRoom = SideRoom(amphipods: [], type: .desert)
        
        for i in stride(from: amphipods.count - 1, through: 0, by: -4) {
            DesertSideRoom.amphipods.insert(Amphipod(description: amphipods[i]), at: 0)
            CopperSideRoom.amphipods.insert(Amphipod(description: amphipods[i-1]), at: 0)
            BronzeSideRoom.amphipods.insert(Amphipod(description: amphipods[i-2]), at: 0)
            AmberSideRoom.amphipods.insert(Amphipod(description: amphipods[i-3]), at: 0)
        }
        sideRooms = (AmberSideRoom, BronzeSideRoom, CopperSideRoom, DesertSideRoom)
        print(self)
    }
    

    
    
    struct SideRoom {
        var amphipods: [Amphipod]
        var type: Amphipod.Species
        
        mutating func moveIn(amphipod: Amphipod) {
            amphipods.append(amphipod)
        }
        
        func notSettledAmphipods() -> Int {
            amphipods.count - amphipods.reversed().prefix { $0.species == type }.count
        }
        
        func canMoveIn(amphipod: Amphipod) -> Bool {
            if amphipod.species != type {
                return false
            }
            
            if amphipods.isEmpty || amphipods.filter({ $0.species == type }).count == amphipods.count {
                return true
            }
            
            return false
        }
        
        func isEmpty() -> Bool {
            return amphipods.isEmpty
        }
    }
    
    struct Hallway: CustomStringConvertible {
        var spaces = [Character](repeating: ".", count: 11)
        var description: String {
            var description = ""
            for space in spaces {
                description.append(space)
            }
            return description
        }
        
//        func getAllowedHallwaySpaces(for sideroom: SideRoom) -> [Int] {
//            var reachableSpaces = getReachableHallwaySpaces(for: sideroom)
//            var notSettledAmphipods = sideroom.notSettledAmphipods()
//            
//        }
        
        func getReachableHallwaySpaces(for sideroom: SideRoom) -> [Int] {
            var range = 0..<0
            switch sideroom.type {
            case .amber:
                let right = spaces[3...].firstIndex { $0 != "." } ?? spaces.count
                let left = spaces[..<2].lastIndex { $0 != "." } ?? -1
                range = left+1..<right
            case .bronze:
                let right = spaces[5...].firstIndex { $0 != "." } ?? spaces.count
                let left = spaces[..<4].lastIndex { $0 != "." } ?? -1
                range = left+1..<right
            case .copper:
                let right = spaces[7...].firstIndex { $0 != "." } ?? spaces.count
                let left = spaces[..<6].lastIndex { $0 != "." } ?? -1
                range = left+1..<right
            case .desert:
                let right = spaces[9...].firstIndex { $0 != "." } ?? spaces.count
                let left = spaces[..<spaces.count].lastIndex { $0 != "." } ?? -1
                range = left+1..<right
            }
            
            return range.filter { $0 != 2 && $0 != 4 && $0 != 6 && $0 != 8 }
        }
    }
    
    struct Amphipod: CustomStringConvertible {
        let species: Species
        var description: String {
            switch species {
            case .amber:
                return "A"
            case .bronze:
                return "B"
            case .copper:
                return "C"
            case .desert:
                return "D"
            }
        }
        
        init(description: String) {
            switch description {
            case "A":
                species = .amber
            case "B":
                species = .bronze
            case "C":
                species = .copper
            case "D":
                species = .desert
            default:
                fatalError("Illegal amphipod detected")
            }
        }
        
        func computeEnergy(forSteps steps: Int) -> Int {
            switch species {
            case .amber:
                return steps
            case .bronze:
                return 10*steps
            case .copper:
                return 100*steps
            case .desert:
                return 1000*steps
            }
        }
        
        enum Species {
            case amber
            case bronze
            case copper
            case desert
        }
    }
}
