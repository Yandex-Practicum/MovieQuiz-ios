//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Ivan on 16.08.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var statisticService: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewControllerProtocol?
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
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
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        self.proceedWithAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        
        
        if isCorrect {
            self.didAnswer(isCorrectAnswer: isCorrect)
        }
        
        viewController?.enabledButtons(isEnabled: false)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            viewController?.enabledButtons(isEnabled: true)
            self.showNextQuestionOrResults()
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            
            guard let gamesCount = statisticService?.gamesCount else { return }
            guard let bestGame = statisticService?.bestGame else { return }
            guard let totalAccuracy = statisticService?.totalAccuracy else { return }
            
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: """
     Ваш результат: \(correctAnswers)/\(self.questionsAmount)
     Количество сыгранных квизов: \(gamesCount)
     Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
     Средняя точность: \(String(format: "%.2f", totalAccuracy))%
     """,
                buttonText: "Сыграть ещё раз",
                completition: { [weak self] in
                    guard let self = self else { return }
                    self.restartGame()
                    self.correctAnswers = 0
                })
            viewController?.alertPresenter?.showQuizResult(for: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
