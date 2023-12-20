//
//  Round.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 19.12.2023.
//

import UIKit

class Round {
    // набор вопросов на раунд
    private var questions: [QuizQuestion]
    // индекс текущего вопроса
    private var currentQuestionIndex: Int = 0
    // количество вопросов с правильным ответом
    private var correctAnswersCount: Int = 0
    // статус раунда
    private var isRoundCompleate: Bool = false
    // результат раунда
    private var gameRecord: GameRecord?

    init(numberOfQuestions: Int) {
        // Получение заданного количества вопросов из фабрики
        self.questions = QuestionFactory().generateRandomQuestion(limit: numberOfQuestions)
    }

    // метод возвращающий текущий вопрос
    func getCurrentQuestion() -> QuizQuestion? {
        if currentQuestionIndex < questions.count {
            return questions[currentQuestionIndex]
        }
        return nil
    }
    
    // метод возвращает номер текущего вопроса
    func getNumberCurrentQuestion() -> Int {
        currentQuestionIndex
    }
    
    // метод возвращает кол-во вопросов в раунде
    func getCountQuestions() -> Int {
        questions.count
    }
    
    // метод возвращает кол-во правильных ответов на впоросы
    func getCorrectCountAnswer() -> Int {
        correctAnswersCount
    }
    
    // метод проверяет правильно ли ответил пользователь и переводит на следующий вопрос
    func checkAnswer(checkTap: Bool) -> Bool {
        guard let currentQuestion = getCurrentQuestion() else {
            return false // Обработка ошибки, если вопрос не найден
        }
        
        let isCorrect = currentQuestion.correctAnswer == checkTap
        if isCorrect {
            correctAnswersCount += 1
        }
        
        currentQuestionIndex += 1
        
        if isRoundComplete() {
            finishRound()
        }
        
        return isCorrect
    }
    
    // метод возвращает структуру GameRecord
    func getGameRecord() -> GameRecord? {
        guard let gameRecord = gameRecord else {
            return nil
        }
        return gameRecord
    }
    
    // приватный метод когда у раунда конец
    private func isRoundComplete() -> Bool {
        return currentQuestionIndex > questions.count - 1
    }

    // приватный метод завершающий раунд
    private func finishRound() {
        isRoundCompleate = true
        let newGameRecord = GameRecord(correct: correctAnswersCount, total: questions.count, date: Date())
        gameRecord = newGameRecord
        StatisticServiceImplementationRound(currentGame: newGameRecord)
    }
}
