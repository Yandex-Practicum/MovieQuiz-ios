//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Sergey Ivanov on 16.01.2024.
//
//

import UIKit

final class MovieQuizPresenter: RoundDelegate {
    //weak var viewController: MovieQuizViewController?
    weak var viewController: MovieQuizViewControllerProtocol?
    private let round: Round?
    private var statisticService: StatisticService?
    
    init(viewController: MovieQuizViewControllerProtocol?) {
        self.viewController = viewController
        self.round = Round()
        round?.delegate = self
        startQuiz()
    }
    
    private func startQuiz() {
        round?.requestNextQuestion()
    }
    
    func didReceiveNewQuestion(_ question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        // показываем вопрос
        viewController?.showQuestion(quiz: self.convert(model: question))
        // включаем кнопки
        viewController?.setAnswerButtonsEnabled(true)
    }
    
    func roundDidEnd(_ round: Round, withResult gameRecord: GameRecord) {
        statisticService = StatisticServiceImplementation()
        viewController?.showQuizResults(model: self.convert(model: statisticService))
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionNumber = round?.getNumberCurrentQuestion() ?? 0
        let totalQuestions = round?.getCountQuestions() ?? 0
        let displayNumber = questionNumber + 1

        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(displayNumber) / \(totalQuestions)"
        )
    }
    
    private func convert(model: StatisticService?) -> AlertModel {
        guard let bestGame = model?.bestGame else {
            return AlertModel(title: "Ошибка", message: "Данные не доступны!", buttonText: "ОК")
        }
        
        let gamesCount = model?.gamesCount ?? 0
        let gamesAccuracy = model?.totalAccuracy ?? 0.0

        let correctAnswers = round?.getCorrectCountAnswer() ?? 0
        let totalQuestions = round?.getCountQuestions() ?? 0

        let recordCorrect = bestGame.correct
        let recordTotal = bestGame.total
        let recordDate = bestGame.date
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: """
            Ваш результат: \(correctAnswers) / \(totalQuestions)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(recordCorrect) / \(recordTotal) (\(recordDate.dateTimeString))
            Средняя точность: \(gamesAccuracy)%
            """,
            buttonText: "Сыграть еще раз"
        )
        return alertModel
    }
    
    func yesButtonClicked() {
        let clickResult = round?.checkAnswer(checkTap: true) ?? false
        viewController?.showQuestionAnswerResult(isCorrect: clickResult)
    }
    
    func noButtonClicked() {
        let clickResult = round?.checkAnswer(checkTap: false) ?? false
        viewController?.showQuestionAnswerResult(isCorrect: clickResult)
    }
}
