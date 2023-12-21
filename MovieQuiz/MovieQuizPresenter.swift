
import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate{
    
    
    var correctAnswers = 0
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private let statisticService: StatisticService!
    private var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewController?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImpl()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool{
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex(){
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion(){
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked(){
        didAnswer(isYes: true)
        self.viewController?.updateButtonStates(buttonsEnabled: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewController?.updateButtonStates(buttonsEnabled: true)
        }
    }
    
    func noButtonClicked(){
        didAnswer(isYes: false)
        self.viewController?.updateButtonStates(buttonsEnabled: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewController?.updateButtonStates(buttonsEnabled: true)
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.hideLoadingIndicator()
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            self.viewController?.showFinalResults()
            viewController?.imageView.layer.borderColor = UIColor.clear.cgColor
        } else {
            viewController?.activityIndicator.color = UIColor.white
            viewController?.activityIndicator.isHidden = false
            viewController?.activityIndicator.startAnimating()
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
            viewController?.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
  
    func loadMovies(){
        questionFactory?.loadData()
    }
    
    func didLoadDataFromServer() {
        viewController?.activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailNextQuestion(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showNetworkError(message: String) {
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            buttonAction: { [weak self] in
                guard let self = self else { return }
                
                resetQuestionIndex()
                correctAnswers = 0
                
                questionFactory?.requestNextQuestion()
            },
            accessibilityIdentifier: "errorAlert"
        )
        alertPresenter?.show(alertModel: model)
    }
    
    func RequestToShowNextQuestion(){
        questionFactory?.requestNextQuestion()
    }
    
    func makeResultMessage() -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else{
            assertionFailure("Error")
            return ""
        }
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlaysCount = "Количество сыгранных квизов:\(statisticService.gamesCount)"
        let currentGameResult = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfo = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" +
        " (\(bestGame.date.dateTimeString))"
        let averageAccuracy = "Средняя точность: \(accuracy)%"
        let resultMessage = [
            currentGameResult, totalPlaysCount, bestGameInfo, averageAccuracy
        ].joined(separator: "\n")
        return resultMessage
    }
}
