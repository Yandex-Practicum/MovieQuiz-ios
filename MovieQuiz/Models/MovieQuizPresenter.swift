//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Алексей on 16.01.2023.
//

import UIKit


final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    
   
    
    
    
    
    let questionsAmount = 10
    private var currentQuestionIndex = 0
    var countCorrectAnswer = 0
    var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var statisticService: StatisticService?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        }
    
   
    
      

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
       }
       
    func resetGame() {
        currentQuestionIndex = 0
        countCorrectAnswer = 0
        questionFactory?.requestNextQuestion()
       }
       
    func switchToNextQuestion() {
        currentQuestionIndex += 1
       }
    
    func yesButtonClicked() {
        didAnswerQuestion(answer: true)
        }
    
    func noButtonClicked() {
        didAnswerQuestion(answer: false)
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            countCorrectAnswer += 1
        }
    }

    private func didAnswerQuestion(answer: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = answer
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        print(currentQuestionIndex)
    }

    func convert(model: QuizQuestion) -> QuizStepViewModel {
            QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                     question: model.text,
                                     questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
    
    private func showAnswerResult(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        print("bug")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            }
        }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    private func completion() {
        self.resetGame()
    }
    
    private func convertAlertModel(model: QuizResultsViewModel) -> AlertModel {
            return AlertModel(title: model.title,
                              message: model.text,
                              buttonText: model.buttonText,
                              completion: completion)
        }

    private func makeResultsMessage() {
        guard let gameCount = statisticService?.gamesCount,
        let accuracy = statisticService?.totalAccuracy,
        let bestGame = statisticService?.bestGame else {return}
        
        let totalAccuracy = (String(format: "%.2f", accuracy))
        let record = "\(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let alertModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                      text: """
                                                       Ваш результат: \(countCorrectAnswer)/10
                                                       Количество завершённых квизов: \(gameCount)
                                                       Рекорд: \(record)
                                                       Средняя точность: \(totalAccuracy)%
                                                       """,
                                                      buttonText: "Сыграть еще раз!")
        let modelResult = convertAlertModel(model: alertModel)
        viewController?.alertPresenter?.show(quiz: modelResult)
    }
    
    private func showNextQuestionOrResults() {
        guard let GameCount = statisticService?.gamesCount else {return }
        guard let correctAnswer = statisticService?.correctAnswer else {return}
        guard let totalQuestions = statisticService?.totalQuestions else {return}
        var allStatisticsCollected = false
        
        if self.isLastQuestion() {
            setNewGameCount(with: GameCount + 1)
            setStoreGameResult(correctAnswersNumber: Int(correctAnswer) + countCorrectAnswer, totalQuestionsNumber: Int(totalQuestions) + questionsAmount)
            setStoreRecord(correct: countCorrectAnswer , total: questionsAmount)
            allStatisticsCollected = true
            if allStatisticsCollected != false {
                makeResultsMessage()
            }
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    func setStoreRecord(correct count: Int, total amount: Int) {
        statisticService?.storeRecord(correct: count, total: amount)
    }
    
    
    func setNewGameCount(with gameCount: Int) {
        statisticService?.setGameCount(gamesCount: gameCount)
        }
    
    func setStoreGameResult(correctAnswersNumber: Int, totalQuestionsNumber: Int) {
            statisticService?.storeGameResult(correctAnswersNumber: correctAnswersNumber, totalQuestionsNumber: totalQuestionsNumber)
        }
    
    
    
}
