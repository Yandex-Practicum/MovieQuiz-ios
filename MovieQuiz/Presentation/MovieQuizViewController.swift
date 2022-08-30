import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noAnswerButton: UIButton!
    @IBOutlet private weak var yesAnswerButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var questionsAmount: Int = 10 // максимальное количество вопросов ответов

    private var currentQuestionIndex: Int = 0 // индекс нашего вопроса
    private var counterCorrectAnswers: Int = 0 // счетчик правильных ответов
    private var numberOfQuizGames: Int = 0 // количетсво сыгранных квизов
    private var recordCorrectAnswers: Int = 0 // рекорд правильных овтетов
    private var recordDate = Date() // дата рекорда
    private var averageAccuracy: Double = 0.0 // среднее кол-во угаданных ответов в %
    private var allCorrectAnswers: Int = 0 // если ответили на все вопросы верно

    private var statisticService = StatisticServiceImpl()
    private var gameCount: Int = 0


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

    // MARK: - Private Functions
    private func show(quiz step: QuizStepViewModel) {
        UIView.animate(withDuration: 0.1) {
            self.textLabel.text = step.question
            self.counterLabel.text = step.questionNumber
            self.imageView.image = step.image
        }
    }

    private func restart() {
        counterCorrectAnswers = 0
        currentQuestionIndex = 0
        setupViewModel()
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? .remove,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }


    private func setupViewModel() {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor

        let statisticService = StatisticServiceImpl()
        self.statisticService = statisticService

        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true

        let alert = UIAlertController(
            title: "Упс! произошла ошибка",
            message: "Попробуйте позднее",
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "Попробовать еще раз",
            style: .default
//            handler: {
//                _ in action
        )
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    private func show(quiz result: QuizResultsViewModel) {

        let alert = ResultAlertPresenter(
            title: result.title,
            message: result.text,
            controller: self,
            actionHandler: { _ in
                self.questionFactory?.requestNextQuestion()
            })
        alert.show()
    }

    private func showNextQuestionOrResults() {
        yesAnswerButton.isEnabled = true
        noAnswerButton.isEnabled = true

        if currentQuestionIndex == questionsAmount - 1 {
            numberOfQuizGames += 1
            allCorrectAnswers += counterCorrectAnswers
            let resultQuiz = getResultQuiz()
        } else {
            currentQuestionIndex += 1
            setupViewModel()
        }
    }

    private func getResultQuiz() {
        var title = "Игра окончена!"
        if counterCorrectAnswers >= recordCorrectAnswers {
            title = "Поздравляем! Новый рекорд!"
            recordCorrectAnswers = counterCorrectAnswers
        }

        if counterCorrectAnswers == numberOfQuizGames {
            title = "Поздравляем! Это лучший результат"
        }
        averageAccuracy = Double(allCorrectAnswers * 100) / Double(questionsAmount * numberOfQuizGames)
        statisticService.store(correct: allCorrectAnswers, total: questionsAmount)
        let resultQuiz = ResultAlertPresenter(
            title: title,
            message: """
                Ваш результат: \(allCorrectAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)
                Средняя точность: \(String(format: "%.2f", averageAccuracy))%
            """,
            controller: self,
            actionHandler: { _ in
                self.restart()
            }
        )
        resultQuiz.show()
        return
    }

    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            counterCorrectAnswers += 1
        }

        yesAnswerButton.isEnabled = false
        noAnswerButton.isEnabled = false
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }


    // MARK: - Status bar and orientations settings

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
}
