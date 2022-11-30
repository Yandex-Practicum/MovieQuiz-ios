import UIKit

private let questionsAmount: Int = 10
private let questionFactory: QuestionFactoryProtocol? = QuestionFactory()
private var currentQuestion: QuizQuestion? = nil

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!

    private var currentQuestion: QuizQuestion? = nil
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.show(quiz: self.convert(model: self.currentQuestion!))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory?.setDelegate(delegate: self)
        initFirstTime()
        showQuestionImpl()
    }

    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }

    private func initFirstTime() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }

    private func show(quiz step: QuizStepViewModel) {
        configureImageLayer(thickness: 0, color: UIColor.ypWhite)
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }

    private func showQuestionImpl() {
        questionFactory?.requestNextQuestion()
    }

    private func showFinalResult() {
        AlertPresenter().show(model: createAlertModel(), controller: self)
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == (questionsAmount - 1) {
            showFinalResult()
            initFirstTime()
        } else {
            currentQuestionIndex += 1
            showQuestionImpl()
        }
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
            configureImageLayer(thickness: 8, color: UIColor.ypGreen)
        }
        else {
            configureImageLayer(thickness: 8, color: UIColor.ypRed)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }

    private func configureImageLayer(thickness: Int, color: UIColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = CGFloat(thickness)
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 15
    }

    private func createResultModel() -> QuizResultsViewModel {
        return QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: "Ваш результат: \(correctAnswers) из \(questionsAmount)",
            buttonText: "Сыграть ещё раз")
    }

    private func createAlertModel() -> AlertModel {
        return convert(model: createResultModel())
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    private func convert(model: QuizResultsViewModel) -> AlertModel {
        return AlertModel(
            title: model.title,
            message: model.text,
            buttonText: model.buttonText) { [weak self] in
                self?.showQuestionImpl()
            }
    }

}
