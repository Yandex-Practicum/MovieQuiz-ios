//
//  GameRecordModel.swift
//  MovieQuiz
//
//  Created by Fedor on 24.11.2023.
//

import Foundation

//Модель результата игры
struct GameRecord:Codable {

    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterResult(currentResult: GameRecord) -> Bool {
        currentResult.correct > correct
    }
    
}
