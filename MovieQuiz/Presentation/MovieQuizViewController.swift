import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8

    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        toggleButton()
        imageView.layer.borderWidth = 8
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        toggleButton()
        imageView.layer.borderWidth = 8
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func toggleButton() {
        yesButton.isEnabled.toggle()
        noButton.isEnabled.toggle()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        return QuizStepViewModel (
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.CustomColors.ypGreen?.cgColor : UIColor.CustomColors.ypRed?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResult()
            self.toggleButton()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 {
            imageView.layer.borderWidth = 0
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard let gamesCount = statisticService?.gamesCount else { return }
            guard let totalAccuracy = statisticService?.totalAccuracy else { return }
            guard let bestGame = statisticService?.bestGame else { return }
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                                    message: """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", totalAccuracy))%
""" ,
                                                    buttonText: "Сыграть еще раз",
                                                    completion: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()})
                                                    
                alertPresenter?.present(alert: alertModel, presentingViewController: self)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
