//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Федор Завьялов on 24.12.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter:QuestionFactoryDelegatePrototocol {
    
    var correctAnswers = 0
    var questionAmount = 10
    private var currentQuestionIndex = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var statisticImplementation: StatisticServiceProtocol = StatisticServiceImplementation()
    private var alertPresenter = AlertPresenter()
    private var questionFactory:QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        questionFactory = QuestionFactory(movieLoader: MovieLoader(), delegate: self)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == givenAnswer)
    }
    
    func didFinishReceiveQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let image = UIImage(data: model.image) ?? UIImage()
        let questionText: String = model.text
        let questionNumber: String = "\(currentQuestionIndex + 1)/\(questionAmount)"
        
        return QuizStepViewModel(image: image, question: questionText, questionNumber: questionNumber)
    }
    
    func showNextQuestionOrResult() {
        if self.isLastQuestion() {
            
            statisticImplementation.store(correct: correctAnswers, total: questionAmount)
            
            //Определяем формат даты в виде 03.06.22 03:22
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YY HH:mm"
            let formattedDate = dateFormatter.string(from: statisticImplementation.bestGame.date)
            
            //Данные для модели Алерта
            let alerTitle = "Этот раунд окончен!"
            let alertMessage = """
            Ваш результат: \(correctAnswers)/\(questionAmount)
            Количество сыгранных квизов: \(statisticImplementation.gamesCount)
            Рекорд: \(statisticImplementation.bestGame.correct)/\(statisticImplementation.bestGame.total) (\(formattedDate))
            Средняя точность: \(String(format: "%.2f", statisticImplementation.totalAccurancy * 100))%
            """
            let alertButtonText = "Сыграть ещё раз"
            
            let alertModel = AlertModel(title: alerTitle, message: alertMessage, buttonText: alertButtonText) { [ weak self ] in
                
                if let selfAction = self {
  
                    selfAction.restartGame()
                    selfAction.questionFactory.requestNextQuestion()
                }
            }
            guard let viewController = viewController else { return }
            alertPresenter.showAlert(quiz: alertModel, controller: viewController)
            
        } else {
            self.switchQuestionIndex()
            questionFactory.requestNextQuestion()
        }
    }
    
    func isLastQuestion () -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func restartGame () {
        correctAnswers = 0
        currentQuestionIndex = 0
    }
    
    func switchQuestionIndex () {
        currentQuestionIndex += 1
    }
    
    func didAnswerCorrect(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            viewController?.imageView.layer.borderColor = UIColor.ypgreen.cgColor
        } else {
            viewController?.imageView.layer.borderColor = UIColor.ypred.cgColor
        }
    }
    
    //MARK: - Описание метдов Делегата
    
    func didFinishReceiveQuestion(question: QuizQuestion?) {
        didFinishReceiveQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        guard let viewController else { return }
        viewController.hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showNetworkError (message: String){
        guard let viewController else { return }
        viewController.hideLoadingIndicator()
        
        let networkConnectionAlert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз"){ [weak self] in
            guard let selfAction = self else {return}
            
//            selfAction.correctAnswers = 0
            selfAction.restartGame()
            selfAction.questionFactory.loadData()
            
        }
        
        alertPresenter.showAlert(quiz: networkConnectionAlert, controller: viewController)
    }
    
}
