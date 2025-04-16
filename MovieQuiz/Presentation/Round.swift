//
//  Round.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 19.12.2023.
//
//

import UIKit

final class Round: QuestionFactoryDelegate {
    
    weak var delegate: RoundDelegate?
    // инициализируем фабрику вопросов
    private let questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
    // текущий вопрос
    private var currentQuestion: QuizQuestion?
    // индекс текущего вопроса
    private var currentQuestionIndex: Int = 0
    // количество вопросов с правильным ответом
    private var correctAnswersCount: Int = 0
    // количество вопросов всего
    private var questionCount = 10
    // результат раунда
    private var gameRecord: GameRecord?
    
    init() {
        questionFactory.delegate = self
        questionFactory.loadData()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        if let question = question {
            self.currentQuestion = question
            delegate?.didReceiveNewQuestion(question)
        } else if isRoundComplete() {
            finishRound()
        }
    }
    
    func didLoadDataFromServer() {
        delegate?.didLoadDataFromServer()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        delegate?.didFailToLoadData(with: error)
    }
    
    func requestNextQuestion() {
        questionFactory.requestNextQuestion()
    }
    
    // метод возвращающий текущий вопрос
    func getCurrentQuestion() -> QuizQuestion? {
        if currentQuestionIndex < questionCount {
            return currentQuestion
        }
        return nil
    }
    
    // метод возвращает номер текущего вопроса
    func getNumberCurrentQuestion() -> Int {
        currentQuestionIndex
    }
    
    // метод возвращает кол-во вопросов в раунде
    func getCountQuestions() -> Int {
        questionCount
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
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.requestNextQuestion()
            }
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
        return currentQuestionIndex >= questionCount
    }
    
    // приватный метод завершающий раунд
    private func finishRound() {
        let newGameRecord = GameRecord(correct: correctAnswersCount, total: questionCount, date: Date())
        gameRecord = newGameRecord
        StatisticServiceImplementation().store(currentRound: self)
        delegate?.roundDidEnd(self, withResult: newGameRecord)
    }
}
