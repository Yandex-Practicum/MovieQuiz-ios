//
//  GameRecordModel.swift
//  MovieQuiz
//
//  Created by Mir on 27.03.2023.
//

import UIKit

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareRecords(correct: Int, total: Int, date: Date) -> GameRecord {
        let newResult = GameRecord(correct: correct, total: total, date: date)
        
        if (self.correct < newResult.correct) {
            return newResult
        } else {
            return self
        }
    }
}
