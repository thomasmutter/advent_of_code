//
//  aoc_puzzle7.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 08/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

var colorScheme = [String: [String]]()
var bagContents = [String: [String: Int]]()

let bagRules = readInput(fileName: "input_p7.txt")

func addColor(key: String, value: String) {
    if colorScheme[key] == nil {
        colorScheme[key] = []
    }
    colorScheme[key]!.append(value)
}

func addContent(bag: String, contentBag: String, quantity: Int) {
    if bagContents[bag] == nil {
        bagContents[bag] = [:]
    }
    bagContents[bag]![contentBag] = quantity
}

func bagRelation(bagText: String) {
    let words = bagText.components(separatedBy: " ")
    let numberOfBags = (words.count-4)/4
    for i in stride(from:4, to: 4*numberOfBags+1, by: 4) {
        addColor(key: words[i+1] + words[i+2], value: words[0] + words[1])
        addContent(bag: words[0] + words[1], contentBag: words[i+1] + words[i+2], quantity: Int(words[i])!)
    }
}

func findOptions(color: String) -> Set<String> {
    var uniqueColors = Set<String>()
    if colorScheme[color] == nil {
        return uniqueColors
    }
    
    for c in colorScheme[color]! {
        uniqueColors.insert(c)
        uniqueColors = uniqueColors.union(findOptions(color: c))
    }
    
    return uniqueColors
}

func totalBagsIn(color: String) -> Int {
    var sum = 0
    if bagContents[color] == nil {
        return 0
    }
    
    for (key, value) in bagContents[color]! {
        sum += (value + value*totalBagsIn(color: key))
    }
    
    return sum
}

func solveP7() {
    bagRules.forEach{ bagRelation(bagText:$0) }
    print(findOptions(color: "shinygold").count)
    print(totalBagsIn(color: "shinygold"))
}
