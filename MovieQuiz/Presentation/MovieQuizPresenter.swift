//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Роман Бойко on 11/14/22.
//

import Foundation

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // Сервис сбора статистики
    private let statisticService: StatisticServiceImplementation!

    // Переменная для подсчёта колличества верных ответов
    private var correctAnswers: Int = 0
    
    // Экземпляр фабрики вопросов
    private var questionFactory: QuestionFactoryProtocol?
    
    // Переменная индекса текущего вопроса
    private var currentQuestionIndex: Int = 0
    
    // Общее колличество вопросов
    private let questionsAmount: Int = 10
    
    // Текущий вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    // Слабая ссылка на ViewController
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Methods
    // Функция для кнопки "Да"
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    // Функция для кнопки "Нет"
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // Функция сравнения ответа пользователя и правильного ответа
    func didAnswer (isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = (isYes == currentQuestion.correctAnswer)
        if isCorrect {
            correctAnswers += 1
        }
        
        self.showAnswerResult(isCorrect: isCorrect)
    }
    
    // Функция преобразования вопроса в вью модель
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: String("\(currentQuestionIndex + 1)/\(questionsAmount)")
        )
    }
    
    // Фунуция для определения последнего вопроса
    func isLastQuestion () -> Bool {
        return currentQuestionIndex == questionsAmount - 1
    }
    
    // Функция для сброса индекса текущего вопроса
    func restartGame () {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.loadData()
    }
    
    // Функция для инкрементирования индекса текущего вопроса
    func switchToNextQuestion () {
        currentQuestionIndex += 1
    }
    
    // Функция для запроса следующего вопроса
    func didReciveNextQuestion (question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // Функция выбора действия: показ результата раунда, если вопрос последний или следующего вопроса
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            
            statisticService.gamesCounterUp()
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let text = self.makeResultsMessage()
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    // Функция формирования сообщения Алерта с результатами раунда и статистикой
    private func makeResultsMessage () -> String {
        let bestGame = statisticService.bestGame
        
        let currentGameResultText = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let totalGamesCounterText = "Колличество сыгранных квизов: \(statisticService.gamesCounterRead())"
        let bestGameResultText = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let avarageAccuracyText = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        return "\(currentGameResultText)\n\(totalGamesCounterText)\n\(bestGameResultText)\n\(avarageAccuracyText)"
    }
    
    // Функция для действий при неудачном походе в сеть
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        print(error)
        print(error.localizedDescription)
        viewController?.showNetworkError(message: message)
    }
    
    // Функция для действий при удачном походе в сеть
    func didloadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    // Функция для отображения рамки с цветовой индикацией правильности ответа и блокировки кнопок на время показа рамки с последующей разблокировкой и скрытием рамки
    func showAnswerResult(isCorrect: Bool){
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self = self else { return }
            self.viewController?.hideImageBoarder()
            self.viewController?.toggleIsEnablebButtons()
            self.showNextQuestionOrResults()
        }
        viewController?.toggleIsEnablebButtons()
    }
}
