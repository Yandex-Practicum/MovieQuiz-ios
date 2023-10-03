import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Outlets & Actions
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var textOfQuestionLabel: UILabel!
    @IBOutlet private weak var indexOfQuestionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        let userAnswer = false
        showAnswerResult(isCorrect: userAnswer)
    }
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        let userAnswer = true
        showAnswerResult(isCorrect: userAnswer)
    }
    // MARK: - Variables, Constants
    private var currentQuizQuestionIndex = 0
    private var userCorrectAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var gameStatistic: StatisticServiceProtocol?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        gameStatistic = StatisticService()
    }
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(_ questionStep: QuizQuestion?) {
        guard let questionStep = questionStep else { return }
        currentQuestion = questionStep
        let viewModel = convert(model: questionStep)
        DispatchQueue.main.async { [weak self] in
            self?.showStep(viewModel)
        }
    }
    // MARK: - Helper methods
    /// метод конвертации модели вопроса квиза во вью модель состояния "Вопрос показан"
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let stepView = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuizQuestionIndex + 1)/\(questionsAmount)")
        return stepView
    }
    /// метод для состояния "Вопрос показан"
    private func showStep(_ step: QuizStepViewModel) {
        moviePosterImageView.image = step.image
        textOfQuestionLabel.text = step.question
        indexOfQuestionLabel.text = step.questionNumber
    }
    /// метод для изменения цвета рамки
    private func showAnswerResult(isCorrect: Bool) {
        moviePosterImageView.layer.masksToBounds = true
        moviePosterImageView.layer.borderWidth = 8
        moviePosterImageView.layer.cornerRadius = 20
        noButton.isEnabled = false
        yesButton.isEnabled = false
        guard let currentQuestion = currentQuestion else { return }
        if isCorrect == currentQuestion.correctAnswer {
            moviePosterImageView.layer.borderColor = UIColor.ypGreen.cgColor
            userCorrectAnswers += 1
        } else {
            moviePosterImageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.moviePosterImageView.layer.borderWidth = 0
            self.moviePosterImageView.layer.borderColor = UIColor.clear.cgColor
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    /// метод перехода в один из сценариев конечного автомата
    private func showNextQuestionOrResults() {
        if currentQuizQuestionIndex == questionsAmount - 1 {
            guard
                let gameStatistic = gameStatistic,
                let bestGame = gameStatistic.bestGame,
                let date = bestGame.date
            else {
                return
            }
            gameStatistic.store(correct: userCorrectAnswers, total: questionsAmount)
            let alertView = AlertModel(
                title: "Этот раунд окончен!",
                message: """
                    Ваш результат: \(userCorrectAnswers)/\(questionsAmount)
                    Количество сыгранных квизов: \(gameStatistic.gamesCount)
                    Рекорд: \(bestGame.correct)/\(bestGame.total) (\(date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", gameStatistic.totalAccuracy))%
                    """,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    guard let self = self else { return }
                    self.currentQuizQuestionIndex = 0
                    self.userCorrectAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                })
            alertPresenter?.showResult(alertView)
        } else {
            currentQuizQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
}
