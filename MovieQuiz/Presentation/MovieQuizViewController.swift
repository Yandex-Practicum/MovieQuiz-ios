import UIKit

enum StyleDefault {
    static let fontBold = "YSDisplay-Bold"
    static let fontMedium = "YSDisplay-Medium"
    static let fontSize = 20.0
    static let borderWidthImageState = 8.0
}

struct Question {
    let image: String
    let text: String
    let rating: Float
    let correctAnswer: Bool
}

struct Quiz {
    var questions: [Question] = []
    var current: Question?
    var index: Int
    var successful: Int
    var failed: Int
    let beginedAt: Date
    var completedAt: Date?

    init() {
        index = 0
        successful = 0
        failed = 0
        beginedAt = Date()
        questions = getQuestions().shuffled()
        current = questions.first
    }

    func accuracy() -> Float {
        return Float(successful) / Float(successful + failed) * 100
    }

    func isComplete() -> Bool {
        return index > questions.count - 1
    }

    mutating func chooseByCurrentIndex() {
        if isComplete() { return }
        current = questions[index]
    }

    mutating func complete() {
        self.completedAt = Date()
    }

    mutating func incrementIndex() {
        index += 1
    }

    private func getQuestions() -> [Question] {
        return [
            Question.init(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 9.2,
                correctAnswer: true),

            Question.init(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 9.0,
                correctAnswer: true),

            Question.init(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 8.1,
                correctAnswer: true),

            Question.init(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 8.0,
                correctAnswer: true),

            Question.init(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 8.0,
                correctAnswer: true),

            Question.init(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 6.6,
                correctAnswer: true),

            Question.init(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 5.8,
                correctAnswer: false),

            Question.init(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 4.3,
                correctAnswer: false),

            Question.init(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 5.1,
                correctAnswer: false),

            Question.init(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                rating: 5.8,
                correctAnswer: false)
        ]
    }
}

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var viewContainer: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerCounterLabel: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!

    // MARK: - Properties

    private var scores: [Quiz] = []
    private var quiz = Quiz()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup view
        configuration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start()
    }

    // MARK: - Logic

    private func start() {
        quiz = Quiz()
        show()
    }

    private func show() {
        if quiz.isComplete() {
            return complete()
        }

        guard let question = quiz.current else {
            return
        }

        enableButtons(true)
        imageViewDefaultState()

        questionImageView.image = UIImage(named: question.image) ?? UIImage(named: "Error")
        questionTextLabel.text = question.text

        headerCounterLabel.text = "\(quiz.index + 1) / \(quiz.questions.count)"

        quiz.incrementIndex()

        print("Show question \"\(question.image)\"")
    }

    private func complete() {
        // quiz closed
        quiz.complete()
        scores.append(quiz)

        print("Quiz completed")

        alertQuizComplete(
            title: "Этот раунд окончен",
            message: generateMessage(),
            buttonText: "Попробовать еще раз"
        )
    }

    private func answerSuccess() {
        imageViewSuccessState()

        quiz.successful += 1
        print("🎉 Succesful!")
    }

    private func answerFail() {
        imageViewFailState()

        quiz.failed += 1
        print("😔 Oops!")
    }

    // MARK: - Private methods

    /// Default configuration View
    private func configuration() {
        // configure view
        viewContainer.backgroundColor = UIColor.appBackground

        // configure question image
        questionImageView.layer.cornerRadius = 20

        // configure header labels
        headerTitleLabel.font = UIFont(
            name: StyleDefault.fontMedium,
            size: StyleDefault.fontSize)

        headerCounterLabel.font = UIFont(
            name: StyleDefault.fontMedium,
            size: StyleDefault.fontSize)

        // configure question text label
        questionTextLabel.font = UIFont(
            name: StyleDefault.fontBold,
            size: 23.0)

        // configure buttons style
        buttonStyle(button: falseButton)
        buttonStyle(button: trueButton)

        print("Completed start configuration")
    }

    /// Default styles UIButton
    // TODO: На сколько я понимаю, в Swift должна быть возможность создания дизайн системы. Типа наследования своего класса от UIButton, но с настройками по-умолчанию. Пока не разобрался как это реализовать.
    private func buttonStyle(button: UIButton) {
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor.appDefault
        button.tintColor = UIColor.appBackground

        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = UIFont(
            name: StyleDefault.fontBold,
            size: StyleDefault.fontSize)

        button.titleEdgeInsets = UIEdgeInsets(
            top: 18.0,
            left: 16.0,
            bottom: 18.0,
            right: 16.0)
    }

    private func imageViewDefaultState() {
        return updateStyleImageView()
    }

    private func imageViewSuccessState() {
        return updateStyleImageView(
            borderWidth: StyleDefault.borderWidthImageState,
            borderColor: UIColor.appSuccess.cgColor)
    }

    private func imageViewFailState() {
        return updateStyleImageView(
            borderWidth: StyleDefault.borderWidthImageState,
            borderColor: UIColor.appFail.cgColor)
    }

    private func updateStyleImageView(
        borderWidth: CGFloat = .nan,
        borderColor: CGColor? = .none
    ) {
        questionImageView.layer.borderColor = borderColor
        questionImageView.layer.borderWidth = borderWidth
    }

    private func checkAnswer(correctAnswer: Bool) {
        guard let question = quiz.current else {
            return
        }

        enableButtons(false)

        question.correctAnswer == correctAnswer
            ? answerSuccess()
            : answerFail()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.quiz.isComplete() {
                return self.complete()
            } else {
                self.quiz.chooseByCurrentIndex()
                self.show()
            }
        }
    }

    // MARK: - IBActions

    @IBAction func falseButtonClicked(_ sender: Any) {
        checkAnswer(correctAnswer: false)
    }

    @IBAction func trueButtonClicked(_ sender: Any) {
        checkAnswer(correctAnswer: true)
    }

    // MARK: - Helper methods

    private func alertQuizComplete(title: String, message: String, buttonText: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)

        alert.addAction(
            UIAlertAction(title: buttonText, style: .default) { _ in
                self.start()
            })

        self.present(alert, animated: true, completion: nil)
    }

    private func generateMessage() -> String {
        let recordScore = getBestScore()

        // TODO: Не совсем догоняю как это работает (повторить темы про синтаксис Swift).
        guard let dateRecordScoreString = recordScore?.completedAt?.dateTimeString else {
            return ""
        }

        // Лучший счет 2/10
        let recordScoreString =
            "\(String(describing: recordScore?.successful ?? 0))/" +
            "\(quiz.questions.count) (\(dateRecordScoreString))"

        // Средняя точность
        let avg = NSString(format: "%.2f", avgAccuracy())

        let message: [String] = [
            "Ваш результат: \(quiz.successful)/\(quiz.questions.count)",
            "Количество сыграных квизов: \(scores.count)",
            "Рекорд: \(recordScoreString)",
            "Средняя точность: \(avg)%"
        ]

        return message.joined(separator: "\n")
    }

    private func getBestScore() -> Quiz? {
        if scores.isEmpty { return nil }

        var bestScore = scores.first ?? quiz

        for score in scores where bestScore.successful < score.successful {
            bestScore = score
        }

        return bestScore
    }

    private func avgAccuracy() -> Float {
        var avgs: [Float] = []

        for score in scores { avgs.append(score.accuracy()) }
        let sum = avgs.reduce(0, +)

        return sum / Float(avgs.count)
    }

    private func enableButtons(_ enable: Bool) {
        trueButton.isEnabled = enable
        falseButton.isEnabled = enable
    }
}
