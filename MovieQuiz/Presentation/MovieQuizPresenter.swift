import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    weak var viewController: MovieQuizViewController?
    var questionFactory: QuestionFactoryProtocol?
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if (isCorrectAnswer) {
            correctAnswers += 1
        }
    }
    
    func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = true
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = false
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
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
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
