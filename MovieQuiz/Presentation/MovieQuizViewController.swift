import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!

    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory!.requestNextQuestion()
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        showQuestion(question: question)
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

    private func showQuestion(question: QuizQuestion) {
        imageView.layer.borderWidth = 0
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.show(quiz: viewModel)
            self.configureButtons(isEnabled: true)
        }
    }

    private func show(quiz step: QuizStepViewModel) {
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
            self.showNextQuestionOrResults()
        }
    }

    private func drawBorder(color: CGColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = color
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showAlert()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }

    private func showAlert() {
        let model = AlertModel(
                title: "Этот раунд окончен!",
                message: "Ваш результат: \(correctAnswers) из 10",
                buttonText: "Сыграть ещё раз") { [weak self] in
            guard let self else {
                return
            }
            (self.currentQuestionIndex, self.correctAnswers) = (0, 0)
            self.questionFactory?.requestNextQuestion()
        }
        let presenter = AlertPresenter(controller: self)
        presenter.show(alertModel: model)
    }
}
