//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Кирилл Марьясов on 16.03.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Переменные и константы
    
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private let statisticService: StatisticService!
    var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
            self.viewController = viewController

        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Method "IsLastQuestion"
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex >= questionsAmount - 1
    }
    
    // MARK: - Method "ResetQuestionIndex"
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    // MARK: - Method "IsLastQuestion"
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // MARK: - Method "RestartGame"
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Method "DidAnswer"
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    // MARK: - Method "Convert"
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    // MARK: - Method "DidAnswer"
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }

        let givenAnswer = isYes

        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    // MARK: - Button Yes
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    // MARK: - Button No
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - Method "DidReceiveNextQuestion"
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.show(quiz: viewModel)
            }
        
    }
    
    // MARK: - Method "ShowNextQuestionOrResults"
    
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - Method "MakeResultsMessage"
    
    func makeResultsMessage() -> String {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            
            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            
            return resultMessage
        }
    
    // MARK: - Method "ShowAnswerResult"
    
    private func proceedWithAnswer(isCorrect: Bool) {
            didAnswer(isCorrectAnswer: isCorrect)
            
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.proceedToNextQuestionOrResults()
            }
        }
    
}
