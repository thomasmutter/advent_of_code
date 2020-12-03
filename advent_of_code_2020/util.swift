//
//  util.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 03/12/2020.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation


func readFile(file: String) -> Array<String> {
    var textArray = [String]()
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(file)
        
        do {
            let text = try String(contentsOf: fileURL, encoding: .utf8)
            textArray = text.components(separatedBy: "\n")
            textArray.removeLast()
        }
        catch {
            print("Couldnt read file")
        }
    }
    return textArray
}

func charAt(word: String, at: Int) -> String {
    let index = word.index(word.startIndex, offsetBy: at)
    return String(word[index])
}
