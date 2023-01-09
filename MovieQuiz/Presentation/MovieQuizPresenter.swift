
import UIKit
final class MovieQuizPresenter: QuestionFactoryDelegate {

    private let questionAmount = 10
    private var correctAnswers = 0
    private var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticService?
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestionIndex = 0
    
    init( viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StaticticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel{
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    // Button click

    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let correctAnswer = currentQuestion.correctAnswer
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == correctAnswer)
        
    }
    
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async {[weak self] in
        self?.viewController?.show(quiz: viewModel)
        }
    }

    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            guard let statisticService = statisticService else {
                return
            }
            statisticService.store(current: correctAnswers, total: self.questionAmount)
            let alertModelResult = AlertModel(title: "Этот раунд окончен",
                                              message: "Ваш результат: \(correctAnswers)/\(self.questionAmount)\n Количество сыгранных квизов: \(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%",
                                              buttonText: "Сыграть еще раз",
                                              completion: { [weak self] _ in
                                                            guard let self = self else {
                                                                return
                                                            }
                                                            self.restartGame()

                                            })
            viewController?.alertPresenter?.showResult(alertModel: alertModelResult)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func didAnswer(isCorrect: Bool) {
        correctAnswers += 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highLightImageBorder(isCorrectAnswer: isCorrect)
        viewController?.buttonsEnable(isEnabled: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            guard let self = self else {
                return
            }
            self.viewController?.buttonsEnable(isEnabled: true)
            self.viewController?.hideBorder()
            self.proceedToNextQuestionOrResults()
            
        })

    }
    
}
