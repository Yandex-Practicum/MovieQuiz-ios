import UIKit

// MARK: - Structures

struct QuizQuestion {
    let image: String
    let rating: Float
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage?
    let question: String
    let stepsTextLabel: String
}

struct QuizScoreViewModel {
    let title: String
    let message: String
    let buttonText: String
}

struct QuizAnswered {
    var succesful: [QuizQuestion] = []
    var failed: [QuizQuestion] = []

    // MARK: - Public methods

    func position() -> Int {
        return succesful.count + failed.count
    }

    mutating func store(question: QuizQuestion, result: Bool) {
        result
            ? succesful.append(question)
            : failed.append(question)
    }
}

/**
    View controller Movie Quiz App
*/
final class MovieQuizViewController: UIViewController {
    // MARK: - Properties

    var quizes: [Quiz] = []
    var currentQuiz: Quiz?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - IBOutlets

    @IBOutlet private var viewContainer: UIView!
    @IBOutlet private weak var quizStepsLabel: ThemeUILabel!
    @IBOutlet private weak var quizImageView: UIImageView!
    @IBOutlet private weak var quizQuestionLabel: UILabel!
    @IBOutlet private weak var falseButton: ThemeUIButton!
    @IBOutlet private weak var trueButton: ThemeUIButton!

    // MARK: - IBActions

    @IBAction private func falseButtonClicked(_ sender: Any) {
        checkAnswer(answer: false)
    }

    @IBAction private func trueButtonClicked(_ sender: Any) {
        checkAnswer(answer: true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createQuiz()
    }

    // MARK: - Private methods

    /// Creating new quiz (start/continue)
    private func createQuiz() {
        currentQuiz = Quiz()
        show(quiz: currentQuiz?.show())
    }

    /// Show the quiz on the screen
    private func show(quiz: QuizStepViewModel?) {
        guard let quiz = quiz else { return }

        quizImageView.image = quiz.image
        quizQuestionLabel.text = quiz.question
        quizStepsLabel.text = quiz.stepsTextLabel

        guard let stepIndex = currentQuiz?.answered.position() else { return }
        print(String("Showed a quiz question #\(stepIndex + 1)"))
    }

    private func checkAnswer(answer: Bool) {
        guard let isCorrectAnswer = currentQuiz?.checkAnswer(answer: answer) else { return }

        if isCorrectAnswer {
            showSuccessImageView()
            print("🎉 The answer is correct")
        } else {
            showFailedImageView()
            print("😔 The answer is NOT correct")
        }

        // buttons disable
        toggleEnableButtons()

        // Go to the next question or wait for results with a delay of 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // buttons enable
            self.toggleEnableButtons()

            self.setImageBorderView()

            let nextQuestion = self.currentQuiz?.show()
            if nextQuestion == nil {
                // complete quiz
                guard let currentQuiz = self.currentQuiz else { return }
                self.storeScore(quiz: currentQuiz)
                self.showScore(currentQuiz: currentQuiz)
            } else {
                self.show(quiz: nextQuestion)
            }
        }
    }

    private func showScore(currentQuiz: Quiz) {
        let score = ViewScore(quizes: quizes)

        let scoreModel = QuizScoreViewModel(
            title: currentQuiz.answered.succesful.count == currentQuiz.questions.count
                ? "🎉 Победа!"
                : "Этот раунд окончен",
            message: score.message(),
            buttonText: "Попробовать еще раз")

        let alert = UIAlertController(
            title: scoreModel.title,
            message: scoreModel.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: scoreModel.buttonText,
            style: .default
        ) {_ in
            self.createQuiz()
        }

        alert.addAction(action)

        self.present(alert, animated: true) {
            // поиск слоя с фоном алерта
            guard let window = UIApplication.shared.windows.first else { return }
            guard let overlay = window.subviews.last?.layer.sublayers?.first else { return }

            // замена цвета фона
            self.animateOverlayColorAlert(overlay, color: StyleDefault.overlayColor)
        }
    }

    private func storeScore(quiz: Quiz) {
        self.quizes.append(quiz)
    }

    private func setImageBorderView(color: UIColor? = .none, width: CGFloat = .nan) {
        self.quizImageView.layer.borderColor = color?.cgColor
        self.quizImageView.layer.borderWidth = width
    }

    private func showSuccessImageView() {
        return setImageBorderView(
            color: UIColor.appSuccess,
            width: StyleDefault.borderWidthShowResult)
    }

    private func showFailedImageView() {
        return setImageBorderView(
            color: UIColor.appFail,
            width: StyleDefault.borderWidthShowResult)
    }

    private func toggleEnableButtons() {
        trueButton.isEnabled.toggle()
        falseButton.isEnabled.toggle()
    }

    private func configuration() {
        viewContainer.backgroundColor = UIColor.appBackground
        quizImageView.layer.cornerRadius = 20
        quizQuestionLabel.font = UIFont(name: StyleDefault.fontBold, size: 23.0)

        print("✅ Configurated storyboard")
    }

    private func animateOverlayColorAlert(_ overlay: CALayer, color: UIColor, alpha: CGFloat = 0.6) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.speed = 0.15

        overlay.add(animation, forKey: nil)

        // fix: моргание 🤷‍♂️, не знаю как это должно быть по другому
        // возможно тут и правильно так, типа другой задачей, но не уверен
        DispatchQueue.main.async {
            overlay.backgroundColor = color.withAlphaComponent(alpha).cgColor
        }
    }
}

/**
    The main functionality of the quiz
*/
class Quiz {
    // MARK: - Properties

    var answered = QuizAnswered()
    let beginedAt: Date
    var completedAt: Date?
    var counterLabelText: String?
    var questions: [QuizQuestion] = []

    init() {
        beginedAt = Date()
        questions = getQuestions().shuffled()
        counterLabelText = getTextForStepsLabel()

        print("🎲 Created a new quiz and shuffled the questions.")
    }

    // MARK: - Public methods

    func show() -> QuizStepViewModel? {
        guard let question = getCurrentQuestion() else { return nil }

        return QuizStepViewModel(
            image: UIImage(named: question.image) ?? UIImage(named: "Error"),
            question: question.text,
            stepsTextLabel: getTextForStepsLabel())
    }

    func checkAnswer(answer: Bool) -> Bool? {
        guard let question = getCurrentQuestion() else { return nil }

        let result = checkAnswer(question: question, answer: answer)
        answered.store(question: question, result: result)

        return result
    }

    func getCurrentQuestion() -> QuizQuestion? {
        let currentPosition = answered.position()

        if currentPosition > questions.count - 1 {
            complete(date: Date())
            return nil
        }

        return questions[currentPosition]
    }

    func complete(date: Date) {
        if answered.position() < questions.count - 1 { return }
        self.completedAt = date

        print("🏁 Completed quiz")
    }

    func percentAccuraty() -> Float {
        return Float(answered.succesful.count) / Float(questions.count) * 100
    }

    // MARK: - Private methods

    private func getTextForStepsLabel() -> String {
        return "\(answered.position() + 1) / \(questions.count)"
    }

    private func checkAnswer(question: QuizQuestion, answer: Bool) -> Bool {
        return question.correctAnswer == answer
    }

    // MARK: - Mock data

    private func getQuestions() -> [QuizQuestion] {
        return [
            QuizQuestion.init(
                image: "The Godfather",
                rating: 9.2,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "The Dark Knight",
                rating: 9.0,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "Kill Bill",
                rating: 8.1,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "The Avengers",
                rating: 8.0,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "Deadpool",
                rating: 8.0,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "The Green Knight",
                rating: 6.6,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),

            QuizQuestion.init(
                image: "Old",
                rating: 5.8,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),

            QuizQuestion.init(
                image: "The Ice Age Adventures of Buck Wild",
                rating: 4.3,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),

            QuizQuestion.init(
                image: "Tesla",
                rating: 5.1,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),

            QuizQuestion.init(
                image: "Vivarium",
                rating: 5.8,
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
    }
}

/**
    Helper class by score message
*/
class ViewScore {
    // MARK: - Properties

    let quizes: [Quiz]

    init(quizes: [Quiz]) {
        self.quizes = quizes
    }

    // MARK: - Public methods

    func message() -> String {
        guard let lastQuiz = quizes.last else { return "" }
        guard let bestResult = bestResult() else { return "" }
        guard let bestDateString = bestResult.completedAt else { return "" }

        let bestScoreString = [
            "\(bestResult.answered.succesful.count)/\(bestResult.questions.count)",
            "(\(bestDateString.dateTimeString))"
        ].joined(separator: " ")

        return [
            "Ваш результат: \(lastQuiz.answered.succesful.count)/\(lastQuiz.questions.count)",
            "Количество сыграных квизов: \(quizes.count)",
            "Рекорд: \(bestScoreString)",
            "Средняя точность: \(NSString(format: "%.2f", accuratyAvg()))%"
        ].joined(separator: "\n")
    }

    /// Search the best quiz
    private func bestResult() -> Quiz? {
        guard var bestScore = quizes.first else { return nil }
        for score in quizes where score.answered.succesful.count > bestScore.answered.succesful.count {
            bestScore = score
        }

        return bestScore
    }

    /// Search for the average accuracy of quizzes
    private func accuratyAvg() -> Float {
        var accuraties: [Float] = []

        for quiz in quizes { accuraties.append(quiz.percentAccuraty()) }

        return accuraties.reduce(0, +) / Float(accuraties.count)
    }
}

// MARK: - Theme

enum StyleDefault {
    static let fontBold = "YSDisplay-Bold"
    static let fontMedium = "YSDisplay-Medium"
    static let fontSize = 20.0
    static let borderWidthShowResult = 8.0
    static let overlayColor = UIColor(
        red: 26 / 255,
        green: 27 / 255,
        blue: 34 / 255,
        alpha: 1)
}

class ThemeUIButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layer.cornerRadius = 15
        tintColor = UIColor.appBackground
        backgroundColor = UIColor.appDefault

        titleLabel?.font = UIFont(
            name: StyleDefault.fontBold,
            size: StyleDefault.fontSize)

        self.titleEdgeInsets = UIEdgeInsets(
            top: 18.0,
            left: 16.0,
            bottom: 18.0,
            right: 16.0)
    }
}

class ThemeUILabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        font = UIFont(
            name: StyleDefault.fontMedium,
            size: StyleDefault.fontSize)
    }
}
