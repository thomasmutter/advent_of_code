//
//  21.swift
//  advent_of_code
//
//  Created by Thomas Mutter on 21/12/2021.
//  Copyright © 2021 thomas. All rights reserved.
//

import Foundation

struct DiracDiceGame {
    func playWithDiracDice() {
        var games = [Game(): 1]
        var turn = 1
        let diceRolls = computeDiceRolls()
        var playerOneWins = 0
        var playerTwoWins = 0
        
        while games.count != 0 {
            print("Turn: \(turn)")
            for game in games.keys {
                let numberOfGames = games[game]!
                games.removeValue(forKey: game)
                for roll in diceRolls {
                    var gameCopy = game
                    gameCopy.move(spaces: roll.key, turn: turn)
                    if gameCopy.hasFinished {
                        if turn % 2 != 0 {
                            playerOneWins += numberOfGames * roll.value
                        } else {
                            playerTwoWins += numberOfGames * roll.value
                        }
                    } else {
                        games.insertOrAdd(numberOfGames * roll.value, forKey: gameCopy)
                    }
                }
            }
            turn += 1
            print("Unique games: \(games.count)")
            print("p1 wins: \(playerOneWins)")
            print("p2 wins: \(playerTwoWins)")
        }
    }
    
    struct Game: Hashable, CustomStringConvertible {
        var description: String {
            "p1 -> (p: \(playerOne.position), s: \(playerOne.score)), p2 -> (p: \(playerTwo.position), s: \(playerTwo.score)) \n"
        }
        var gameTurn: Int = 0
        var playerOne = Player(position: 6)
        var playerTwo = Player(position: 9)
        var hasFinished = false
        
        mutating func move(spaces: Int, turn: Int) {
            gameTurn = turn
            if turn % 2 == 0 {
                let newPosition = (playerTwo.position + spaces) % 10
                playerTwo.position = newPosition == 0 ? 10 : newPosition
                playerTwo.score += playerTwo.position
                if playerTwo.score >= 21 {
                    hasFinished = true
                }
            } else {
                let newPosition = (playerOne.position + spaces) % 10
                playerOne.position = newPosition == 0 ? 10 : newPosition
                playerOne.score += playerOne.position
                if playerOne.score >= 21 {
                    hasFinished = true
                }
            }
        }
        
        struct Player: Hashable {
            var score = 0
            var position: Int
        }
    }
    
    
    func computeDiceRolls() -> [Int: Int] {
        var map = [Int: Int]()
        
        for i in 1...3 {
            for j in 1...3 {
                for k in 1...3 {
                    map.insertOrIncrement(i + j + k)
                }
            }
        }
        return map
    }
    
//    func play() {
//        var p1Score = 0
//        var p2Score = 0
//        var p1Pos = 6
//        var p2Pos = 9
//        var diceRolls1 = [6, 4, 2, 0, 8]
//        var diceRolls2 = [5, 3, 1, 9, 7]
//        var turn = 0
//        var total = 0
//        var total2 = 0
//        while p1Score < 1000 {
//            p1Pos += diceRolls1[turn]
//            p1Score += (p1Pos % 10)
//            turn = (turn + 1) % 5
//            total += 1
//        }
//
//        turn = 0
//
//        for i in 0..<167 {
//            p2Pos += diceRolls2[turn]
//            p2Score += (p2Pos % 10)
//            turn = (turn + 1) % 5
//        }
//
//        print(p1Score)
//        print(p2Score)
//        print(total)
//
//        print(p2Score * (168*3 + 167*3))
//    }
}
