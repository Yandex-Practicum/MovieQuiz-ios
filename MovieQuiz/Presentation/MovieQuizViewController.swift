import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var questionForUser: UILabel!
    @IBOutlet private var questionNumber: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

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

    private let questionsAmount: Int = 1
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizeQuestion?
    private var questionNumberGlobal: Int = 0, corrects: Int = 0, wrongs: Int = 0
    private var currentViewModel = QuizeStepViewModel(image: Data(), question: "", questionNumber: "")
    private var resultsViewModel = QuizeResultsViewModel(title: "", text: "")
    private var accuracy: [Double] = []
    private var avgAccuracy: Double = 0.0
    private var sumAccuracy = 0.0
    private var buttonsBlocked = false
    private let greenColor: CGColor = UIColor(named: "YCGreen")!.cgColor
    private let redColor: CGColor = UIColor(named: "YCRed")!.cgColor
    private let statisticService = StatisticServiceImplementation()
    private let moviesLoader = MoviesLoader()

    private func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        return QuizeStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(questionNumberGlobal + 1)/\(questionsAmount)"
        )
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
        let alert = ResultAlertPresenter(title: "Ошибка", message: message, controller: self, completion: {
            
        })
        alert.show()
    }

    private func show(quize step: QuizeStepViewModel) {
        moviePoster.layer.borderWidth = 0
        currentViewModel = step
        moviePoster.image = UIImage(data: currentViewModel.image)
        questionForUser.text = currentViewModel.question
        questionNumber.text = currentViewModel.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    private func show(quize result: QuizeResultsViewModel) {
        statisticService.store(correct: corrects, total: questionsAmount)
        corrects = 0
        questionNumberGlobal = 0
        
        let alert = ResultAlertPresenter(title: result.title, message: result.text, controller: self, completion: { result in
            print("here")
            self.questionFactory?.requestNextQuestion()
        })
            
        alert.show()
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
            resultsViewModel.text = "Ваш результат: \(corrects)/\(questionsAmount)\n"
            resultsViewModel.text += "Количество сыграных квизов:\(statisticService.gamesCount)\n"
            resultsViewModel.text += "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))"
            resultsViewModel.text += "\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            show(quize: resultsViewModel)
            return
        }
        questionFactory?.requestNextQuestion()
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        moviePoster.layer.masksToBounds = true // даём разрешение на рисование рамки
        moviePoster.layer.borderWidth = 0 // толщина рамки
        moviePoster.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        moviePoster.layer.cornerRadius = 20 // радиус скругления углов рамки
        questionFactory = QuestionFactory(moviesLoader: moviesLoader, delegate: self)
        print("Question Factory in viewDidLoad initialized")
        questionFactory?.loadData()
    }

    // MARK: QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizeQuestion?) {
        guard
            let question = question
        else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quize: viewModel)
        }
    }

    func didLoadDataFromServer() {
        print("questionFactory called delegate didLoadDataFromServer")
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
