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
