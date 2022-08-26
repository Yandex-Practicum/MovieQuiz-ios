import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var questionForUser: UILabel!
    @IBOutlet private var questionNumber: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBAction func showAlert(_ sender: UIButton) {
        /*let callback = {
            print("Hello")
        }
        let alert = ResultAlertPresenter(title: "TITLE", message: "MESSAGE", controller: self, completion: @escaping () -> Void)
        alert.show()*/
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        // print("CQ: "+currentQuestion!.image)
        if !currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        // print("CQ: "+currentQuestion!.image)
        if currentQuestion.correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }

    private let questionsAmount: Int = 3
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizeQuestion?
    private var questionNumberGlobal: Int = 0, corrects: Int = 0, wrongs: Int = 0, rounds: Int = 0, records: Int = 0, average: Float = 0.0, recordDate: String = ""
    private var currentViewModel = QuizeStepViewModel(image: "", question: "", questionNumber: "")
    private var resultsViewModel = QuizeResultsViewModel(title: "", text: "")
    private var accuracy: [Double] = []
    private var avgAccuracy: Double = 0.0
    private var sumAccuracy = 0.0
    private var buttonsBlocked = false
    private let greenColor: CGColor = UIColor(named: "YCGreen")!.cgColor
    private let redColor: CGColor = UIColor(named: "YCRed")!.cgColor
    private let statisticService = StatisticServiceImplementation()

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
        let alert = ResultAlertPresenter(title: "Ошибка", message: message, controller: self)
        alert.show()
    }
    private func show(quize step: QuizeStepViewModel) {
        moviePoster.layer.borderWidth = 0
        currentViewModel = step
        moviePoster.image = UIImage(named: currentViewModel.image)
        questionForUser.text = currentViewModel.question
        questionNumber.text = currentViewModel.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    private func show(quize result: QuizeResultsViewModel) {
        /*let someClosure: (QuizeQuestion) -> () = { question in
            self.show(quize: self.convert(model: question))
        }*/
        statisticService.store(correct: corrects, total: questionsAmount)
        corrects = 0
        wrongs = 0
        questionNumberGlobal = 0
        let alert = ResultAlertPresenter(title: result.title, message: result.text, controller: self/*, someClosure: someClosure(currentQuestion!)*/)
        alert.show()
        /*guard let tmpQuestion = self.currentQuestion else {
            return
        }
        self.show(quize: self.convert(model: tmpQuestion))*/
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
            wrongs += 1
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
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        moviePoster.layer.masksToBounds = true // даём разрешение на рисование рамки
        moviePoster.layer.borderWidth = 0 // толщина рамки
        moviePoster.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        moviePoster.layer.cornerRadius = 20 // радиус скругления углов рамки
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        let aaa: MoviesLoader = MoviesLoader()
        aaa.loadMovies(handler: { result in
            switch result {
            case .success(let films):
                print("Error message in JSON is: " + films.errorMessage)
                print("Quantity of films is: \(films.items.count)")
                print("First Film is: \(films.items.first)")
            case .failure(let error):
                print(error)
            }
        })
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
}
