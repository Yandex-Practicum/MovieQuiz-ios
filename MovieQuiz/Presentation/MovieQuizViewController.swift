import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var questionForUser: UILabel!
    @IBOutlet private var questionNumber: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var movieTitle: UILabel!

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        if !currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }

    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizeQuestion?
    private var questionNumberGlobal: Int = 0, corrects: Int = 0, wrongs: Int = 0
    private var currentViewModel = QuizeStepViewModel(image: Data(), question: "", questionNumber: "", title: "")
    private var resultsViewModel = QuizeResultsViewModel(title: "", text: "")
    private var accuracy: [Double] = []
    private var avgAccuracy: Double = 0.0
    private var sumAccuracy = 0.0
    private var buttonsBlocked = false
    private let greenColor: CGColor = UIColor(named: "YCGreen")!.cgColor
    private let redColor: CGColor = UIColor(named: "YCRed")!.cgColor
    private let statisticService: StatisticService = StatisticServiceImplementation()
    private let moviesLoader = MoviesLoader()

    private func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        return QuizeStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(questionNumberGlobal + 1)/\(questionsAmount)",
            title: model.title
        )
    }

    private func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.movieTitle.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }

    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alert = ResultAlertPresenter(
            title: "Ошибка сети",
            message: message,
            buttonText: "OK",
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            alert.show()
        }
    }

    private func showImageLoadError(message: String) {
        let alert = ResultAlertPresenter(
            title: "Ошибка загрузки изображения",
            message: message,
            buttonText: "OK",
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            self.movieTitle.isHidden = false
            alert.show()
        }
    }

    private func showJSONErrorMessage(message: String) {
        let alert = ResultAlertPresenter(
            title: "Ошибка в полученных данных",
            message: message,
            buttonText: "OK",
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            self.movieTitle.isHidden = false
            alert.show()
        }
    }

    private func showErrorMessage(message: String) {
        let alert = ResultAlertPresenter(
            title: "Ошибка",
            message: message,
            buttonText: "OK",
            controller: self,
            actionHandler: { _ in }
        )
        DispatchQueue.main.async {
            self.movieTitle.isHidden = false
            alert.show()
        }
    }

    private func show(quize step: QuizeStepViewModel) {
        moviePoster.layer.borderWidth = 0
        currentViewModel = step
        moviePoster.image = UIImage(data: currentViewModel.image)
        questionForUser.text = currentViewModel.question
        questionNumber.text = currentViewModel.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
        hideLoadingIndicator()
        movieTitle.text = "Наименование фильма:\n\(currentViewModel.title)"
    }

    private func show(quize result: QuizeResultsViewModel) {
        corrects = 0
        questionNumberGlobal = 0

        let alert = ResultAlertPresenter(
            title: result.title,
            message: result.text,
            buttonText: "Сыграть еще раз!",
            controller: self,
            actionHandler: { _ in
                self.showLoadingIndicator()
                self.questionFactory?.requestNextQuestion()
            }
        )
        DispatchQueue.main.async {
            alert.show()
        }
    }

    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        moviePoster.layer.borderWidth = 8
        if isCorrect {
            moviePoster.layer.borderColor = greenColor
            corrects += 1
        } else {
            moviePoster.layer.borderColor = redColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        questionNumberGlobal += 1
        guard questionNumberGlobal < questionsAmount else {
            if corrects != questionsAmount {
                resultsViewModel.title = "Этот раунд окончен!"
            } else {
                resultsViewModel.title = "Потрясающе!"
            }
            statisticService.store(correct: corrects, total: questionsAmount)
            resultsViewModel.text = "Ваш результат: \(corrects)/\(questionsAmount)\n"
            resultsViewModel.text += "Количество сыграных квизов:\(statisticService.gamesCount)\n"
            resultsViewModel.text += "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
            resultsViewModel.text += "\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            show(quize: resultsViewModel)
            return
        }
        showLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moviePoster.layer.masksToBounds = true
        self.moviePoster.layer.borderWidth = 0
        self.moviePoster.layer.borderColor = UIColor.white.cgColor
        self.moviePoster.layer.cornerRadius = 20
        self.movieTitle.isHidden = true
        questionFactory = QuestionFactory(moviesLoader: moviesLoader, delegate: self)
        questionFactory?.loadData()
    }

    // MARK: QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizeQuestion?) {
        guard
            let question = question
        else {
            questionFactory?.requestNextQuestion()
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        hideLoadingIndicator()
        DispatchQueue.main.async { [weak self] in
            self?.show(quize: viewModel)
        }
    }

    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }

    func didFailToLoadImage(with error: Error) {
        showImageLoadError(message: error.localizedDescription)
    }

    func didReceiveErrorMessageInJSON(errorMessage errorMess: String) {
        showJSONErrorMessage(message: errorMess)
    }

    func didReceiveErrorMessage(errorMessage errorMess: String) {
        showErrorMessage(message: errorMess)
    }
}
