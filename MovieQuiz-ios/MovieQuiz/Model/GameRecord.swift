//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Maxim Rustamov on 11.01.2023.
//

import Foundation

struct GameRecord: Codable {
     let correct: Int
     let total: Int
     let date: Date
 }

 extension GameRecord: Comparable {
     static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
         return lhs.correct < rhs.correct
     }
     static func <= (lhs: GameRecord, rhs: GameRecord) -> Bool {
         return lhs.correct <= rhs.correct
     }
     static func >= (lhs: GameRecord, rhs: GameRecord) -> Bool {
         return lhs.correct >= rhs.correct
     }
     static func > (lhs: GameRecord, rhs: GameRecord) -> Bool {
         return lhs.correct > rhs.correct
     }
 }
