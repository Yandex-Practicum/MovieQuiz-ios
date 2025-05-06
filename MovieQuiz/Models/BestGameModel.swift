//
//  GameRecordModel.swift
//  MovieQuiz
//
//  Created by Александра Коснырева on 14.09.2023.
//

import Foundation
// создаем сообщение об игре
struct BestGame: Codable {
    let correct: Int // количество правильных ответов
    let total: Int // количество вопросов квиза
    let date: Date //  дата
    
    func isBetterThan(_ another: BestGame) -> Bool {
            correct > another.correct
        }
    }
//extension BestGame: Comparable {
//    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
//      //  lhs.correct < rhs.correct
//        lhs.correct < rhs.correct
//    }
//    }
    
   

    
