//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Дышлюк on 14.02.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticService!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    private var currentQuestion: QuizQuestion?
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func didLoadDataFromServer() {
            viewController?.hideLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
        
    func didFailToLoadData(with error: Error) {
            let message = error.localizedDescription
            viewController?.showNetworkError(message: message)
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
    
    func isLastQuestion() -> Bool{
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame(){
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
        
    }
    
    func switchToNextQuestion(){
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool){
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
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
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!" // ОШИБКА 1: `correctAnswers` не определено
                
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel) // ОШИБКА 2: `show(quiz:)` не определён
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion() // ОШИБКА 3: `questionFactory` не определено
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if (isCorrectAnswer) { correctAnswers += 1 }
    }
    
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
    
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }

}
