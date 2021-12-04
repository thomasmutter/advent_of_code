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
        textArray.removeLast()

    } catch {
        print("File not found")
    }
    return textArray
}

func charAt(word: String, at: Int) -> String {
    let index = word.index(word.startIndex, offsetBy: at)
    return String(word[index])
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
}
