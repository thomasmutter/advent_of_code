//
//  6.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 06/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

var fishbowl: [Int:Int] = [:]

//ttb = time to breed
func computeTotalNumberOfLanternFish(afterDays days: Int) {
    var ttbCounts: [Int:Int] = [:]
    readInput(fileName: "2021_6").first!.split(separator: ",").map { Int($0)!}.forEach {
        if let count = ttbCounts[$0] {
            ttbCounts[$0] = count + 1
        } else {
            ttbCounts[$0] = 1
        }
    }

    let totalNumberOfFish = ttbCounts.map { ttb, occurrences in
        return occurrences + occurrences * countFish(for: lanternFishBirthdays(from: days, firstTimeOffset: ttb))
    }.reduce(0, +)
    print(totalNumberOfFish)
}

func countFish(for days: [Int]) -> Int {
    if days.isEmpty { return 0 }
    
    var totalFish = 0
    for day in days {
        if let numberOfFish = fishbowl[day] {
            totalFish += numberOfFish
        } else {
            let newBornFish =  (1 + countFish(for: lanternFishBirthdays(from: day)))
            fishbowl[day] = newBornFish
            totalFish += newBornFish
        }
    }
    return totalFish
}

func lanternFishBirthdays(from day: Int, firstTimeOffset: Int = 9) -> [Int] {
    var birthdays = [Int]()
    let firstBirthday = day - firstTimeOffset
    if firstBirthday > 0 { birthdays.append(firstBirthday) } else { return birthdays }
    for i in stride(from: firstBirthday - 7, to: 0, by: -7) {
        birthdays.append(i)
    }
    return birthdays
}
