//
//  20.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 20/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

struct ScanImageEnhancer {
    let imageEnhanceAlgorithm: [Character]
    var image: Image
    
    init() {
        let input = readInput(fileName: "2021_20", separator: "\n\n")
        imageEnhanceAlgorithm = input.first!.map { $0 }.filter { $0 != "\n"}
        image = Image(contents: input.last!.map { $0 }.filter { $0 != "\n"}, width: input.last!.map { $0 }.filter { $0 == "\n"}.count + 1)
        image.padImage(expandBy: 2, with: ".")
    }
    
    mutating func enhance(stepCount: Int) {
        for enhancleCycle in 0..<50 {
            var imageCopy = image
            for i in 0..<image.contents.count {
                let neighbors = image.contents.getNeighborIndices(for: i, width: image.width, with: .allAndSelf)
                if neighbors.count < 8 {
                    if enhancleCycle % 2 == 0 {
                        imageCopy.contents[i] = "#"
                    } else {
                        imageCopy.contents[i] = "."
                    }
                    continue
                }
                imageCopy.contents[i] = outputPixel(for: neighbors)
            }
            image = imageCopy
            if enhancleCycle % 2 == 0 {
                image.padImage(expandBy: 1, with: "#")
            } else {
                image.padImage(expandBy: 1, with: ".")
            }
        }
        print(image.contents.filter { $0 == "#"}.count)
    }
    
    func outputPixel(for neighbors: [Int]) -> Character {
        return imageEnhanceAlgorithm[neighbors.map { image.contents[$0] }.enumerated().reduce(0) { acc, x in
            if x.1 == "#" {
                return acc + 1 << (8 - x.0)
            }
            return acc
        }]
    }
    
    
    struct Image {
        var contents: [Character]
        var width: Int
        
        mutating func padImage(expandBy padding: Int = 2, with character: Character) {
            var stub = [Character](repeating: character, count: contents.count + width * 4 * padding + padding * 4 * padding)
            let oldWidth = width
            width += padding*2
            
            for (index, char) in contents.enumerated() {
                stub[padding * width + index + padding + (index / oldWidth) * 2 * padding] = char
            }
            
            contents = stub
        }
        
        func description() -> String {
            var imageString = ""
            for (index, char) in contents.enumerated() {
                if index % width == 0 {
                    imageString += "\n"
                }
                imageString.append(char)
            }
            return imageString
        }
    }
}
