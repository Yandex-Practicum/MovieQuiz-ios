import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func createBorder (isCorrectAnswer: Bool)
    func hideBorder()
    
    func showLoadingIndicator()
    func hideLoadindIndicator()
    
    func showNetworkError(message: String)
}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var currentQuestionIndex = 0
    let questionAmount = 10
    var correctAnswers: Int = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewControllerProtocol?
    var currentGame = GameRecord(correct: 0, total: 10, date: Date())
    var statisticService: StatisticService
    var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController

        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func resetGame() {
        currentQuestionIndex = 0
        currentGame.correct = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func answerIs(answer: Bool) {
        self.showAnswerResult(isCorrect: answer == currentQuestion?.correctAnswer)
    }
    
    func yesButtonClicked() {
        answerIs(answer: true)
    }
    
    func noButtonClicked() {
        answerIs(answer: false)
    }
    
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService.store(correct: currentGame.correct, total: currentGame.total) // сравниваем рекорд с текущей игрой
            viewController?.show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                                            text: "Ваш результат: \(currentGame.correct) из \(currentGame.total)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%",
                                                            buttonText: "Сыграть еще раз"))
            questionFactory?.resetIndex()
        } else {
            self.switchToNextQuestion() // увеличиваем индекс текущего вопроса на 1; таким образом мы сможем получить следующий вопрос
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        viewController?.createBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
            self?.viewController?.hideBorder()
        }
        if isCorrect { self.didAnswer(isCorrectAnswer: isCorrect) }
        
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            currentGame.correct += 1
        }
    }
    
    // MARK: - QuestionFactoryDelegate
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
    
    func didLoadDataFromServer() {
        viewController?.hideLoadindIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
