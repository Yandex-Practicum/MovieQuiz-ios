//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Григорий Сухотин on 11.12.2022.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount: Int = 10
    
    private var currentQuestionIndex = 0
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticService!
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    
    
    
    var isLastQuestion: Bool {
        get {
            currentQuestionIndex == questionsAmount - 1
        }
    }
    
    init(controller: MovieQuizViewControllerProtocol) {
        self.viewController = controller
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.viewController?.showLoadingIndicator()
        self.questionFactory?.loadData()
        self.statisticService = StatisticServiceImplementation()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.loadData()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
        questionFactory?.requestNextQuestion()
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnwser = isYes
        showAnwserResult(isCorrect: givenAnwser == currentQuestion.correctAnswer)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func makeResultsMessage() -> String {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            
            let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let currentGameResultLine = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
            let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total)"
            + " (\(bestGame.date.dateTimeString))"
            let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let resultMessage = [
                currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
            ].joined(separator: "\n")
            
            return resultMessage
    }
    
    
    func showNextQuestionOrResult() {
        viewController?.resetAnwserResult()
        if isLastQuestion {
            statisticService.store(correct: correctAnswers, total: 10)
            let resultModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers)/10", buttonText: "Сыграть еще раз")
            viewController?.show(quiz: resultModel)
        }else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func showAnwserResult(isCorrect: Bool) {
        viewController?.highlightBorders(isCorrect: isCorrect)
        correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        viewController?.disableAnswerButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResult()
            self.viewController?.enableAnswerButtons()
        }
    }
    
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
