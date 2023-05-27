//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Mikhail Vostrikov on 25.05.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate  {
    let questionsCount: Int = 10
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    var statisticService: StatisticService?
    var questionFactory: QuestionFactory?
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    init() { questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImpl()
        questionFactory?.loadData()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsCount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionsCount)"
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: questionNumber
        )
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didReceiveQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = convert(model: question)
        self.viewController?.show(quiz: viewModel)
    }
    
    func showNextQuestionOrResults () {
        self.viewController?.toggleButtonsInteraction(true)
        if self.isLastQuestion() {
            showFinalResults()
            self.viewController?.showFinalResults()
        } else {
            switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    func makeResultMessage() -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error message")
            return ""
        }
        
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        
        let components: [String] = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ]
        let resultMessage = components.joined(separator: "\n")
        
        return resultMessage
    }
    
    func showFinalResults() {
        let statisticService = self.statisticService
        
        statisticService?.store(correct: correctAnswers, total: questionsCount)
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
}
