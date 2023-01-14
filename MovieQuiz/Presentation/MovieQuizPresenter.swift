//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Арсений Убский on 10.01.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    //MARK - lets and variables
    private let questionsAmount: Int = 10 //кол-во вопросов
    private var currentQuestionIndex: Int = 0 //индекс текущего вопроса
    private var currentQuestion: QuizQuestion? //текущий вопрос
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticService!
    private var alertPresenter: AlertPresenterProtocol?
    weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
            statisticService = StatisticServiceImplementation()
            self.viewController = viewController
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
        
        private func didRecieveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            }
        }
    
    //MARK - functions
    
        private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.viewController?.interactionEnable()
            self.proceedToNextQuestionOrResults()
        }
    }
    
        private func makeResultsMessage() -> String {
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
    
        private func proceedToNextQuestionOrResults() { //метод показа следующего вопроса или алерта с результатами
            if self.isLastQuestion() {
                // сохраняем значения правильных ответов за этот раунд и количества вопросов за этот раунд
                statisticService?.store(correct: correctAnswers, total: self.questionsAmount)

                            guard let bestGame = statisticService?.bestGame else {
                                return
                            }
                            guard let gamesCount = statisticService?.gamesCount else {
                                return
                            }
                            guard let totalAccuracy = statisticService?.totalAccuracy else {
                                return
                            }
                let title = "Этот раунд окончен!"
                let buttonText = "Сыграть еще раз"
                let text = "Ваш результат: \(correctAnswers)/\(self.questionsAmount)\n Количество сыграных квизов: \(gamesCount) \n Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString)) \n Средняя точность: \(String(format:"%.2f", totalAccuracy))%"
                
                let alertModel = AlertModel(
                    title: title,
                    message: text,
                    buttonText: buttonText,
                    completion: { [weak self] in
                                    guard let self = self else { return }
                                    self.restartGame()
                                    self.questionFactory?.requestNextQuestion()
                                 })
                    viewController?.alertPresenter?.show(results: alertModel)
            } else {
                self.switchToNextQuestion()
                questionFactory?.requestNextQuestion()
            }
        }
    
        func factoryLoadData() {
            questionFactory?.loadData()
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
    
        private func didAnswer(isYes: Bool) {
                guard let currentQuestion = currentQuestion else {
                    return
                }
                let givenAnswer = isYes
                proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
            }
    
        func yesButtonAction() {
            didAnswer(isYes: true)
        }
        
        func noButtonAction() {
            didAnswer(isYes: false)
        }

        private func isLastQuestion() -> Bool {
                currentQuestionIndex == questionsAmount - 1
            }
            
        func restartGame() {
                currentQuestionIndex = 0
                correctAnswers = 0
                questionFactory?.requestNextQuestion()
            }
            
        private func switchToNextQuestion() {
                currentQuestionIndex += 1
            }
        
        private func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(
                image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
                question: model.text, // берём текст вопроса
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
        }
    }
