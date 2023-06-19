//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Almira Khafizova on 16.06.23.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int //количество правильных ответов
    let total: Int //количество вопросов квиза
    let date: Date //датa завершения раунда
    
    //функция оператора сравнения < между двумя объектами типа GameRecord
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct //сравнение свойств correct каждого объекта GameRecord и возвращает true, если левый операнд меньше правого, и false в противном случае.
    }
}



