//
//  GameRecordModel.swift
//  MovieQuiz
//
//  Created by Fedor on 24.11.2023.
//

import Foundation

//Модель результата игры
struct GameRecord:Codable {
    //Лучший количество ответов в игре
    var correct: Int
    //Количество игр сыграно
    var total: Int
    //Дата игры
    var date: Date
    
    func isBetterResult(currentResult: GameRecord) -> Bool {
        currentResult.correct > correct
    }
    
}
