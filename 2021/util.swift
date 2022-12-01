//
//  util.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 03/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation


func readInput(fileName: String, separator: String = "\n") -> Array<String> {
    let path = URL(fileURLWithPath: "/Users/thomas.mutter/XcodeProjects/advent_of_code/inputs/")
    let fileURL = path.appendingPathComponent(fileName)
    var textArray = [String]()
    do {
        let contents = try String(contentsOf: fileURL, encoding: .utf8)
        textArray = contents.components(separatedBy: separator)
        textArray = textArray.filter { !$0.isEmpty }

    } catch {
        print("File not found")
    }
    return textArray
}

func readIntegerGrid(from filePath: String) -> [Int] {
    readInput(fileName: filePath)
        .joined()
        .map { $0.wholeNumberValue! }
}

func charAt(word: String, at: Int) -> String {
    let index = word.index(word.startIndex, offsetBy: at)
    return String(word[index])
}

func incrementOrWrap(_ value: Int, base: Int = 10) -> Int {
    if value >= base {
        return value % base + 1
    }

    return value % base
}

extension String {
    // from https://coderedirect.com/questions/408155/swift-splitting-strings-with-regex-ignoring-search-string
    func split(usingRegex pattern: String) -> [String] {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: self, range: range)
        let ranges = [startIndex..<startIndex] + matches.map{Range($0.range, in: self)!} + [endIndex..<endIndex]
        return (0...matches.count).map {String(self[ranges[$0].upperBound..<ranges[$0+1].lowerBound])}
    }

    func substring(from start: Int, to end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        return String(self[startIndex..<endIndex])
    }
    
    func mostCommonCharacter() -> Character {
        self.reduce(into: [Character: Int]()) { acc, char in
            acc.insertOrIncrement(char)
        }.sorted(by: { $0.value > $1.value }).first!.key
    }
    
    func mostCommonCharacterCount() -> Int {
        self.reduce(into: [Character: Int]()) { acc, char in
            acc.insertOrIncrement(char)
        }.sorted(by: { $0.value > $1.value }).first!.value
    }
    
    func leastCommonCharacter() -> Character {
        self.reduce(into: [Character: Int]()) { acc, char in
            acc.insertOrIncrement(char)
        }.sorted(by: { $0.value < $1.value }).first!.key
    }
    
    func leastCommonCharacterCount() -> Int {
        self.reduce(into: [Character: Int]()) { acc, char in
            acc.insertOrIncrement(char)
        }.sorted(by: { $0.value < $1.value }).first!.value
    }
    
    func allUpperCase() -> Bool {
        self.filter { $0.isLowercase }.count == 0
    }
    
    func allLowerCase() -> Bool {
        self.filter { $0.isUppercase }.count == 0
    }
}

extension Character {
    func add(_ other: Character) -> String {
        String([self, other])
    }
}

extension Dictionary where Value == Int {
    mutating func insertOrIncrement(_ key: Key) {
        if let count = self[key] {
            self[key] = count + 1
        } else {
            self[key] = 1
        }
    }
    
    mutating func insertOrAdd(_ value: Value, forKey key: Key) {
        if let count = self[key] {
            self[key] = count + value
        } else {
            self[key] = value
        }
    }
}


extension Array {
    func getNeighborIndices(for index: Int, width: Int, with neighborCategory: Neighbors) -> [Int] {
        var neighbors = neighborIndices(for: neighborCategory, width: width)
            .map { $0 + index }.filter { $0 >= 0 && $0 < self.count }
        
        if index % width == 0 {
            neighbors = neighbors.filter { $0 % width != width - 1 }
        }
        
        if index % width == width - 1 {
            neighbors = neighbors.filter { $0 % width != 0 }
        }
        
        return neighbors
    }
    
    func neighborIndices(for neighborCategory: Neighbors, width: Int) -> [Int] {
        switch neighborCategory {
        case .allAndSelf:
            return [-width - 1, -width, -width + 1, -1, 0, +1, +width - 1, +width, +width + 1]
        case .all:
            return [-width - 1, -width, -width + 1, -1, +1, +width - 1, +width, +width + 1]
        case .orthogonal:
            return [+1, -1, +width, -width]
        case .diagonal:
            return [+width + 1, +width - 1, -width + 1, -width - 1]
        case .rightAndDown:
            return [+1, +width]
        }
    }
    
    enum Neighbors {
        case allAndSelf
        case all
        case orthogonal
        case diagonal
        case rightAndDown
    }
    
    func reduce1(_ reduction: (Element, Element) -> Element) -> Element {
        self[1...].reduce(self[0], reduction)
    }
}
