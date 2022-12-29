//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Александр Ершов on 07.12.2022.
//

import Foundation

struct GameRecord : Codable, Comparable {
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }

    static func == (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct == rhs.correct
    }
     let correct: Int
     let total: Int
     let date: Date

     func toString() -> String {
         return "\(correct)/\(total) (\(date.dateTimeString))"
     }

    func compare(count: GameRecord) -> Bool {
        count.correct > self.correct
    }
 }
