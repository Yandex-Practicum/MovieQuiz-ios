//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Aleksandr Eliseev on 03.11.2022.
//

import Foundation

struct GameRecord: Codable {
    
    var correct: Int
    var total: Int
    var date: Date
    
    init(correct: Int, total: Int, date: Date) {
        self.correct = correct
        self.total = total
        self.date = date
    }
    
//    func comparingRecords(currentGame: GameRecord) -> Bool {
//        if currentGame.correct > correct { return true
//        } else {
//            return false
//        }
//    }
    }
