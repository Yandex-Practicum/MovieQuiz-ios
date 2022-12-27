
import UIKit
final class MovieQuizPresenter {
    let questionAmount = 10
    private var currentQuestionIndex = 0
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
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    // Button click
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
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
        viewController?.showAnswerResult(isCorrect: givenAnswer == correctAnswer)
        
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
    var correctAnswers = 0
    var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticService?
    var alertPresenter: AlertPresenter?
    func showNextQuestionOrResults() {
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
                                                            self.correctAnswers = 0
                                                            self.resetQuestionIndex()
                                                            self.questionFactory?.requestNextQuestion()
                                            })
            alertPresenter?.showResult(alertModel: alertModelResult)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
