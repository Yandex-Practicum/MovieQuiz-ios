//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Арсений Убский on 10.01.2023.
//

import UIKit

final class MovieQuizPresenter {
    //MARK - lets and variables
    let questionsAmount: Int = 10 //кол-во вопросов
    private var currentQuestionIndex: Int = 0 //индекс текущего вопроса
    var currentQuestion: QuizQuestion? //текущий вопрос
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewController?
    var statisticService: StatisticService?
    var alertPresenter: AlertPresenterProtocol?
    
    //MARK - functions
    
    func showNextQuestionOrResults() { //метод показа следующего вопроса или алерта с результатами
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
                                self.correctAnswers = 0
                                self.resetQuestionIndex()
                                self.questionFactory?.requestNextQuestion()
                             })
            viewController?.alertPresenter?.show(results: alertModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
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
            
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    
    func yesButtonAction() {
        didAnswer(isYes: true)
    }
    
    func noButtonAction() {
        didAnswer(isYes: false)
    }

    func isLastQuestion() -> Bool {
            currentQuestionIndex == questionsAmount - 1
        }
        
        func resetQuestionIndex() {
            currentQuestionIndex = 0
        }
        
        func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
}
