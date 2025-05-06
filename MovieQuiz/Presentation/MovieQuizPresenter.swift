//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Артур  Арсланов on 20.01.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticService!
    
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0

    
    init(viewController: MovieQuizViewControllerProtocol){
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
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let question = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return question
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
    
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.proceedToNextQuestionOrResults()

        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            viewController?.showAlert()
            viewController?.chooseIsEnableButtons(true)
        } else {
            viewController?.chooseIsEnableButtons(true)
            viewController?.showLoadingIndicator()
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func makeResultMessage() -> String {
        var resultMessage = ""
        if let statisticService = statisticService {
            
            let bestGame = statisticService.bestGame
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
            resultMessage = """
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Ваш результат: \(correctAnswers)\\\(questionsAmount)
                Рекорд: \(bestGame.correct)\\\(questionsAmount) (\(bestGame.date.dateTimeString))
                Средняя точность: \(accuracy)%
            """
        }
        return resultMessage
        
    }
    
    func yesButtonPressed() {
        didAnswer(isYes: true)
    }
    
    func noButtonPressed() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.loadData()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}
