//
//  3.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 03/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

func findGammaAndEpsilon() {
    let diagnostics = readInput(fileName: "2021_3").map { $0.map { Int(String($0))! } }
    let counts = diagnostics.reduce(Array(repeating: 0, count: diagnostics.first!.count)) { total, binaryNumber in
        total.enumerated().map { index, bit in bit + binaryNumber[index] }
    }
    let gamma = UInt(counts.map { $0 <= diagnostics.count / 2 ? 0 : 1}.map { String($0) }.joined(), radix: 2)!
    let epsilon = applyNotOperator(on: gamma, for: diagnostics.first!.count)
    print(gamma * epsilon)
}

func findO2GenAndCO2ScrubRatings() {
    let diagnostics = readInput(fileName: "2021_3")
    
    // Double work is done in the first recursion step of findRating
    let binaryOxygenGeneratorRating = findRating(for: diagnostics) { $0 == "1" } arraySelector: { $0.count <= $1.count ? $1 : $0 }
    let binaryCo2ScrubberRating = findRating(for: diagnostics) { $0 == "1" } arraySelector: { $0.count <= $1.count ? $0 : $1 }
    let oxygenGeneratorRating = UInt(binaryOxygenGeneratorRating, radix: 2)!
    let co2ScrubberRating = UInt(binaryCo2ScrubberRating, radix: 2)!
    
    print(oxygenGeneratorRating*co2ScrubberRating)
    
}

func findRating(for data: Array<String>, index: Int = 0, predicate: (String) -> Bool, arraySelector: (Array<String>, Array<String>) -> Array<String>) -> String {
    if data.count == 1 { return data.first! }
    var dataCopy = data
    let p = dataCopy.partition { binaryNumber in
        predicate(charAt(word: binaryNumber, at: index))
    }
    
    let filteredDiagnostics = arraySelector(Array(dataCopy[..<p]), Array(dataCopy[p...]))
    return findRating(for: filteredDiagnostics, index: index + 1, predicate: predicate, arraySelector: arraySelector)
}

func applyNotOperator(on byte: UInt, for lastNumberOfBits: Int) -> UInt {
    let x = ~byte << (UInt.bitWidth - lastNumberOfBits)
    return x >> (UInt.bitWidth - lastNumberOfBits)
}
