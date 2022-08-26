import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noAnswerButton: UIButton!
    @IBOutlet private weak var yesAnswerButton: UIButton!

    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var questionsAmount: Int = 10 // максимальное количество вопросов ответов

    private var currentQuestionIndex: Int = 0 // индекс нашего вопроса
    private var correctAnswers: Int = 0 // счетчик правильных ответов
    private var numberOfQuizGames: Int = 0 // количетсво сыгранных квизов
    private var recordCorrectAnswers: Int = 0 // рекорд правильных овтетов
    private var recordDate = Date() // дата рекорда
    private var averageAccuracy = 0.0 // среднее кол-во угаданных ответов в %
    private var allCorrectAnswers: Int = 0 // если ответили на все вопросы верно

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
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

    // MARK: - Actions

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }

        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }

        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }

    private func show(quiz step: QuizStepViewModel) {
        UIView.animate(withDuration: 0.1) {
            self.textLabel.text = step.question
            self.counterLabel.text = step.questionNumber
            self.imageView.image = step.image
        }
    }

    // показываем алерт
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default,
            handler: { _ in
                self.restart()
            })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? .remove,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    private func restart() {
        correctAnswers = 0
        currentQuestionIndex = 0
        setupViewModel()
    }

    private func setupViewModel() {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }

        yesAnswerButton.isEnabled = false
        noAnswerButton.isEnabled = false
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        yesAnswerButton.isEnabled = true
        noAnswerButton.isEnabled = true
        if currentQuestionIndex == questionsAmount - 1 {
            allCorrectAnswers += correctAnswers
            numberOfQuizGames += 1
            let resultQuiz = getResultQuiz()
            show(quiz: resultQuiz)
        } else {
            currentQuestionIndex += 1
            setupViewModel()
        }
    }

    private func getResultQuiz() -> QuizResultsViewModel {
        var title = "Игра окончена!"
        if correctAnswers >= recordCorrectAnswers {
            title = "Поздравляем! Новый рекорд!"
            recordCorrectAnswers = correctAnswers
        }

        if correctAnswers == numberOfQuizGames {
            title = "Поздравляем! Это лучший результат"
        }
        averageAccuracy = Double(allCorrectAnswers * 100) / Double(questionsAmount * numberOfQuizGames)
        let resultQuiz = QuizResultsViewModel(
            title: title,
            text: """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(numberOfQuizGames)
                Рекорд: \(recordCorrectAnswers)/\(questionsAmount) \(recordDate.dateTimeString)
                Средняя точность: \(String(format: "%.02f", averageAccuracy))%
            """,
            buttonText: "Новая игра")
        return resultQuiz
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
}
