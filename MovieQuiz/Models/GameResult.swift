//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Flymetric on 23.02.2026.
//
import Foundation

struct GameResult {
    let correct: Int    // количество правильных ответов
    let total: Int      // количество вопросов квиза
    let date: Date      // дата завершения раунда
    
    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
