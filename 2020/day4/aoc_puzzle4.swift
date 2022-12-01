//
//  aoc_puzzle4.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 04/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

let passportStrings = readInput(fileName: "input_p4.txt", separator: "\n\n").map { ps in ps.replacingOccurrences(of: "\n", with:" ")}
let patternMap = ["byr": "19[2-9][0-9]|200[0-2]",
                  "iyr": "20(1[0-9]|20)",
                  "eyr": "20(2[0-9]|30)",
                  "hgt":"1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in",
                  "hcl":"#[0-9a-f]{6}",
                  "ecl":"(amb|blu|brn|gry|grn|hzl|oth)",
                  "pid":"[0-9]{9}",
                  "cid":".*"]



func toDict(text: String) -> Dictionary<String, String> {
    var passport: Dictionary<String, String> = [:]
    text.components(separatedBy: " ").map { string in string.components(separatedBy: ":") }.forEach { entry in passport[entry[0]] = entry[1] }
    return passport
}

func correctDict(dict: Dictionary<String, String>) -> Bool {
    return dict.allSatisfy {(key, value) in isValid(pattern: patternMap[key]!, text: value) } && ((dict.count == 7 && dict["cid"] == nil) || dict.count == 8)
}

func isValid(pattern: String, text: String) -> Bool {
    let range = NSRange(location: 0, length: text.count)
    let regex = try! NSRegularExpression(pattern: pattern)
    if let result = regex.firstMatch(in: text, options: [], range: range) {
        return String(text[Range(result.range, in:text)!]).count == text.count
    }
    return false
}

func solveP4() {
    print(passportStrings.map { toDict(text: $0) }.filter{ correctDict(dict: $0)}.count)
}

