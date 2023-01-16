//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Мария Авдеева on 13.01.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private lazy var questionFactory: QuestionFactoryProtocol? = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    private weak var viewController: MovieQuizViewController?
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        let gameCount: GameCount = GameCount(countOfGames: statisticService.gamesCount.countOfGames + 1)
        statisticService.gamesCount = gameCount
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message, alertPresenter: alertPresenter)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if (isCorrectAnswer) { correctAnswers += 1 }
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        guard let viewController else { return }
        if self.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestRecord = statisticService.bestGame
            let totalCount = statisticService.gamesCount.countOfGames
            let totalAccuracy = statisticService.totalAccuracy?.totalAccuracyOfGame
            let totalAccuracyString: String
            if let totalAccuracy = totalAccuracy {
                totalAccuracyString = "Средняя точность: \(Int(totalAccuracy * 100))%"
            } else {
                totalAccuracyString = "Нет статистики"
            }
            
            let text = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)\n
            Количесчтво сыгранных квизов: \(totalCount)\n
            Рекорд: \(bestRecord.correct)/\(bestRecord.total) \(bestRecord.date.dateTimeString)\n
            \(totalAccuracyString)
            """
            viewController.imageView.layer.borderWidth = 0
            let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть ещё раз", completion: { [weak self] in
                guard let self = self else {return}
                self.restartGame()
                self.questionFactory?.requestNextQuestion()
            })
            alertPresenter.present(alert: alertModel, presentingViewController: viewController)
            
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            viewController.imageView.layer.borderWidth = 0
            return
        }
    }
    
    func yesButtonTapped() {
        didAnswer(isYes: true)
    }
    
    func noButtonTapped() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}



