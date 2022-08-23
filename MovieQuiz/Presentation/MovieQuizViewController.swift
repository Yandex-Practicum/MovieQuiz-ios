import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var moviePoster: UIImageView!
    @IBOutlet private var questionForUser: UILabel!
    @IBOutlet private var questionNumber: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBAction func showAlert(_ sender: UIButton) {
        /*let callback = {
            print("Hello")
        }
        let alert = ResultAlertPresenter(title: "TITLE", message: "MESSAGE", controller: self, completion: @escaping () -> Void)
        alert.show()*/
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let tmpcurrentQuestion = currentQuestion else {
            return
        }
        // print("CQ: "+currentQuestion!.image)
        if !currentQuestion!.correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let tmpcurrentQuestion = currentQuestion else {
            return
        }
        // print("CQ: "+currentQuestion!.image)
        if currentQuestion!.correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }

    private let questionsAmount: Int = 3
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizeQuestion?
    private var questionNumberGlobal: Int = 0, corrects: Int = 0, wrongs: Int = 0, rounds: Int = 0, records: Int = 0, average: Float = 0.0, recordDate: String = ""
    private var currentViewModel: QuizeStepViewModel = QuizeStepViewModel(image: "", question: "", questionNumber: "")
    private var resultsViewModel: QuizeResultsViewModel = QuizeResultsViewModel(title: "", text: "")
    private var accuracy: [Double] = []
    private var avgAccuracy: Double = 0.0
    private var sumAccuracy: Double = 0.0
    private var buttonsBlocked: Bool = false
    private let greenColor: CGColor = UIColor(named: "YCGreen")!.cgColor
    private let redColor: CGColor = UIColor(named: "YCRed")!.cgColor
    private let statisticService = StatisticServiceImplementation()

    private func convert(model: QuizeQuestion) -> QuizeStepViewModel {
        return QuizeStepViewModel(image: model.image, question: model.text, questionNumber: "\(questionNumberGlobal + 1)/\(questionsAmount)")
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
        }
        else {
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
            rounds += 1
            if corrects > records {
                records = corrects
                let temporaryDateVar = Date()
                recordDate = temporaryDateVar.dateTimeString
            }
            if corrects > 0 {
                accuracy.append((Double(corrects) / Double(questionsAmount)) * 100.0)
            } else {
                accuracy.append(0.0)
            }
            if !accuracy.isEmpty {
                sumAccuracy = 0.0
                for element in accuracy {
                    sumAccuracy += element
                }
                // print(sumAccuracy)
                avgAccuracy = sumAccuracy / Double(accuracy.count)
            }
            if corrects != questionsAmount {
                resultsViewModel.title = "Этот раунд окончен!"
            }
            else {
                resultsViewModel.title = "Потрясающе!"
            }
            resultsViewModel.text = "Ваш результат: \(corrects)/\(questionsAmount)\nКоличество сыграных квизов:\(rounds)\nРекорд: \(records)/\(questionsAmount) (\(recordDate))"
            resultsViewModel.text += "\nСредняя точность: \(avgAccuracy)%"
            show(quize: resultsViewModel)
            return
        }
        questionFactory?.requestNextQuestion()
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // INIT UserDefaults
        enum Keys: String {
            case correct, total, bestGame, gamesCount
        }
        struct GameRecord: Codable {
            let correct: Int
            let total: Int
            let date: Date
        }
        if UserDefaults.standard.string(forKey: Keys.correct.rawValue) == nil {
            UserDefaults.standard.set(0, forKey: Keys.correct.rawValue)
        }
        if UserDefaults.standard.string(forKey: Keys.total.rawValue) == nil {
            UserDefaults.standard.set(0, forKey: Keys.total.rawValue)
        }
        if UserDefaults.standard.string(forKey: Keys.gamesCount.rawValue) == nil {
            UserDefaults.standard.set(0, forKey: Keys.gamesCount.rawValue)
        }
        if UserDefaults.standard.data(forKey: Keys.bestGame.rawValue) == nil {
            let game = GameRecord(correct: 0, total: 0, date: Date())
            guard let data = try? JSONEncoder().encode(game) else {
                return
            }
            UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
        }
        // -----------------
        moviePoster.layer.masksToBounds = true // даём разрешение на рисование рамки
        moviePoster.layer.borderWidth = 0 // толщина рамки
        moviePoster.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        moviePoster.layer.cornerRadius = 20 // радиус скругления углов рамки
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
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
