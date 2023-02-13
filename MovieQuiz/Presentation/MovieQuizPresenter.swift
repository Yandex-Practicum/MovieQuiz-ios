
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let statisticService: StatisticService!
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswerQuestion: Int = 0
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswerQuestion = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    func didAnswerQuestion(isCorrect: Bool) {
        if isCorrect {
            correctAnswerQuestion += 1
            
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func proceedToNextQuestionResults(){
        
        if self.isLastQuestion(){
            self.statisticService?.store(correct: correctAnswerQuestion, total: questionsAmount)
            
            
            let text = "Ваш результат: \(correctAnswerQuestion)/\(questionsAmount) \n Количество сыграных квизов: \(self.statisticService?.gamesCount ?? 0) \n      Рекорд: \(self.statisticService?.bestGame.correct ?? 0)/\(questionsAmount) (\(self.statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString )) \n Средняя точность: \(String(format: "%.2f", 100*(self.statisticService?.totalAccuracy ?? 0)/Double(self.statisticService?.gamesCount ?? 0)))%"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            self.correctAnswerQuestion = 0
            self.viewController?.show(quiz: viewModel)
        }
        else {
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswerQuestion(isCorrect: isCorrect)
        viewController?.hightLightImageBorder(isCorrectAnswer: isCorrect)
        viewController?.yesButtonIsEnabled(result: false)
        viewController?.noButtonIsEnabled(result: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let self = self else{return}
            
            self.viewController?.yesButtonIsEnabled(result: true)
            self.viewController?.noButtonIsEnabled(result: true)
            self.proceedToNextQuestionResults()
        }
        
    }
}

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz rezult: QuizResultsViewModel)
    func hightLightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func yesButtonIsEnabled(result: Bool)
    func noButtonIsEnabled(result: Bool)
}
