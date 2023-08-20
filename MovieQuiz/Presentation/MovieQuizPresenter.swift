//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by TATIANA VILDANOVA on 19.08.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Properties
    private let statisticService: StatisticService
    private var questionFactory: QuestionFactoryProtocol
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private var currentQuestion: QuizQuestion?
    private let questionsAmount = 10
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var isButtonsEnabled = true
    
    // MARK: - Initialization
    init(viewController: MovieQuizViewControllerProtocol,
         questionFactory: QuestionFactoryProtocol,
         statisticService: StatisticService) {
        self.viewController = viewController
        self.questionFactory = questionFactory
        self.statisticService = statisticService
        self.questionFactory.delegate = self
        loadDataFromJSON()
        questionFactory.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate Methods
    func didLoadDataFromServer() {
        print("Данные успешно загружены с сервера.")
        viewController?.hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        print("Не удалось загрузить данные с сервера:", error)
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
        viewController?.hideLoadingIndicator()
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
    
    // MARK: - Helper Methods
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory.requestNextQuestion()
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    func showResults(with viewModel: QuizResultsViewModel) {
        viewController?.show(quiz: viewModel)
    }
    func playAgainButtonClicked() {
        restartGame()
    }
    
    // MARK: - User Interaction Methods
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    private func didAnswer(isYes: Bool) {
        guard isButtonsEnabled, let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    private func proceedWithAnswer(isCorrect: Bool) {
        isButtonsEnabled = false
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            isButtonsEnabled = true
        }
    }
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = correctAnswers == self.questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            showResults(with: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
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
    // MARK: - Private Methods
    // Вспомогательный метод для загрузки данных из JSON
    private func loadDataFromJSON() {
        guard let fileURL = getJSONFileURL() else {
            print("Не удалось получить путь к JSON файлу.")
            return
        }
        do {
            let data = try Data(contentsOf: fileURL)
            guard (try? JSONDecoder().decode(Top.self, from: data)) != nil else {
                print("Ошибка при декодировании JSON")
                return
            }
            // Декодирование успешно, вы можете использовать объект result
        } catch {
            print("Ошибка при загрузке данных: \(error.localizedDescription)")
        }
    }
    // Вспомогательный метод для получения пути к JSON файлу
    private func getJSONFileURL() -> URL? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "top250MoviesIMDB.json"
        let fileURL = documentsURL.appendingPathComponent(fileName)
        print(NSHomeDirectory())
        return fileURL
    }
}

