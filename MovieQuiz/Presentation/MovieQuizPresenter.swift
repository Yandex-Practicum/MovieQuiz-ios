//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Верповский on 20.04.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Private Properties
    private final var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private final var statisticService: StatisticServiceProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImpl()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private  func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    private  func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func resetCorrectAnswers() {
        correctAnswers = 0
    }
    
    private func itCorrectAnswer() {
        correctAnswers += 1
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.show(quiz: viewModel)
        }
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        self.viewController?.blockButton(isBlocked: false)
        if isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            let alertModel = AlertModel(
                title: "Этот раунд окончен",
                message: createMessage(),
                buttonText: "Сыграть еще раз") { [weak self] _ in
                    guard let self else { return }
                    self.switchToNextQuestion()
                    self.resetQuestionIndex()
                    self.questionFactory?.requestNextQuestion()
                }
            self.viewController?.show(quiz: alertModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        self.proceedWithAnswer(isCorrect: currentQuestion.correctAnswer == isYes)
    }
    
    private func didAnswer(isCorrectAnswer: Bool){
        if (isCorrectAnswer) { correctAnswers += 1 }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func createMessage() -> String {
        guard let statisticService else { return "" }
        let bestGame = statisticService.bestGame
        let result: String = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let count: String = "Количество сыгранных игр: \(statisticService.gamesCount)"
        let record: String = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let totalAccuracy: String = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        return [result, count, record, totalAccuracy].joined(separator: "\n")
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
}
