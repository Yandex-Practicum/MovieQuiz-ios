import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol!
    private var statisticService: StatisticService!
    private var alertPresenter: AlertPresenter!
    private var startNewGameCallback: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGameCallback = { [weak self] in
            guard let self else {
                return
            }
            self.startNewGame()
        }
        imageView.layer.cornerRadius = 20
        alertPresenter = AlertPresenter()
        questionFactory = QuestionFactory(delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory.requestNextQuestion()
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        showCurrentQuestion()
    }

    @IBAction func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        configureButtons(isEnabled: false)
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    @IBAction func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        configureButtons(isEnabled: false)
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    private func configureButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(
                title: "Ошибка",
                message: message,
                buttonText: "Попробовать еще раз",
                completion: startNewGameCallback)
        alertPresenter.show(view: self, model: model)
    }

    private func showCurrentQuestion() {
        DispatchQueue.main.async { [weak self] in
            guard let self, let question = self.currentQuestion else {
                return
            }
            let viewModel = self.convert(model: question)
            self.show(quiz: viewModel)
            self.configureButtons(isEnabled: true)
        }
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        drawBorder(color: isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else {
                return
            }
            self.showNextQuestionOrResult()
        }
    }

    private func drawBorder(color: CGColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color
    }

    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            showResult()
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }

    private func showResult() {
        let model = AlertModel(
                title: "Этот раунд окончен!",
                message: formatResultMessage(),
                buttonText: "Сыграть ещё раз",
                completion: startNewGameCallback)
        alertPresenter.show(view: self, model: model)
    }

    private func startNewGame() {
        (currentQuestionIndex, correctAnswers) = (0, 0)
        questionFactory.requestNextQuestion()
    }

    private func formatResultMessage() -> String {
        let bestGame = statisticService.bestGame
        return """
               Ваш результат: \(correctAnswers) из \(questionsAmount)
               Количество сыгранных квизов: \(statisticService.gamesCount)
               Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
               Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy * 100))%
               """
    }

}
