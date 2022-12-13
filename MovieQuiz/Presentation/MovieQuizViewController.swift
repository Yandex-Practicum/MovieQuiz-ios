import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private var currentQuestion: QuizQuestion? = nil
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    private let questionsAmount: Int = 5
    private let questionFactory: QuestionFactoryProtocol? =
        QuestionFactoryImdb(moviesLoader: MoviesLoader())
    //private let questionFactory: QuestionFactoryProtocol? =
    //    QuestionFactoryMockData()
    private let statisticService: StatisticServiceProtocol? =
        StatisticServiceUserDefaults()
    private let alertPresenter = AlertPresenter()

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

    func didLoadDataFromServer() {
        showLoadingIndicator(isLoad: false)
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
        loadMoviesData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory?.setDelegate(delegate: self)
        initFirstTime()
        loadMoviesData()
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

    private func loadMoviesData() {
        showLoadingIndicator(isLoad: true)
        questionFactory?.loadData()
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
        alertPresenter.show(model: createAlertModel(), controller: self)
    }

    private func showNextQuestionOrResults() {
        makeButtonsEnable(isEnable: true)
        if currentQuestionIndex == (questionsAmount - 1) {
            if let stat = statisticService {
                stat.store(correct: correctAnswers, total: questionsAmount)
            }
            showFinalResult()
            initFirstTime()
        } else {
            currentQuestionIndex += 1
            showQuestionImpl()
        }
    }

    private func showAnswerResult(isCorrect: Bool) {
        makeButtonsEnable(isEnable: false)
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

    private func makeButtonsEnable(isEnable: Bool) {
        noButton.isEnabled = isEnable
        yesButton.isEnabled = isEnable
    }

    private func configureImageLayer(thickness: Int, color: UIColor) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = CGFloat(thickness)
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 15
    }

    private func createTextResult() -> String {
        let currentResult = "Ваш результат: \(correctAnswers) из \(questionsAmount)"
        guard let stat = statisticService else {
            return currentResult
        }
        let accuracy = "\(String(format: "%.2f", stat.totalAccuracy))"
        return """
        \(currentResult)
        Количество сыгранных квизов: \(stat.gamesCount)
        Рекорд: \(stat.bestGame.toString())
        Средняя точность: \(accuracy)%
        """
    }

    private func createResultModel() -> QuizResultsViewModel {
        return QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: createTextResult(),
            buttonText: "Сыграть ещё раз")
    }

    private func createAlertModel() -> AlertModel {
        return convert(model: createResultModel())
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
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

    private func showLoadingIndicator(isLoad: Bool) {
        if isLoad {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }

    private func showNetworkError(message: String) {
        showLoadingIndicator(isLoad: false)
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") {
            }
        alertPresenter.show(model: model, controller: self)
    }

}
