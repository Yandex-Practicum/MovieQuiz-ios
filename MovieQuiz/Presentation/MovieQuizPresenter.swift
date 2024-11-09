import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    internal var questionFactory: QuestionFactoryProtocol?
    private var statistics: StatisticServiceProtocol!
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        statistics = StatisticService()
    }
    
    internal func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    internal func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    internal func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    internal func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    internal func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    internal func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            if let statistics = statistics {
                statistics.store(correct: correctAnswers, total: questionsAmount) }
            let string1 = "Ваш результат: \(correctAnswers)/10"
            let string2 = "Количество сыгранных квизов: \(statistics?.gamesCount ?? 0 )"
            let string3 = "Рекорд: \(statistics?.bestGame.correct ?? 0)/\(statistics?.bestGame.total ?? 0) (\((statistics?.bestGame.date.dateTimeString ?? Date().dateTimeString)))"
            let string4 = "Средняя точность: \(String(format: "%.2f", statistics?.totalAccuracy ?? 0)) %"
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: "\(string1) \n\(string2) \n\(string3) \n\(string4)",
                buttonText: "Сыграть ещё раз"
            ) { self.viewController?.alertPresenterDidPresent()
            }
            viewController?.showResult(quiz: viewModel) }
        else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    internal func convert(model: QuizQuestion) -> QuizStepViewModel {
        let output = QuizStepViewModel.init(image: UIImage(data: model.image) ?? UIImage(),
                                            question: model.text,
                                            questionNumber: String(currentQuestionIndex+1)+"/"+String(questionsAmount))
        return output
    }
    
    internal func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    internal func didAnswer(isCorrectAnswer: Bool) {
        isCorrectAnswer ? correctAnswers += 1 : nil
    }
    
    internal func showAnswerResult(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            viewController?.showLoadingIndicator()
            showNextQuestionOrResults()
        }
    }
}
