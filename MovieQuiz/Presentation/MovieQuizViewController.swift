import UIKit
final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
        
    private let main = DispatchQueue.main
    
    private var questionsAmount = 10
    private var questionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex: Int = 0
    private var rightAnswers = 0
    private var quizCount = 0
    private var maxRightAnswers = 0
    private var allRightAnswers = 0
    private var allAnswers = 0

    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionFactory.requestNextQuestion { [weak self] question in
            guard
                    let self = self,
                    let question = question
            else {
                // Ошибка
                return
            }

            self.currentQuestion = question
            let viewModel = self.convert(model: question)
            DispatchQueue.main.async {
                self.show(quiz: viewModel)
            }
        }
        setupMainImage()
    }
    
    // MARK: - Setup
    
    private func setupMainImage() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    
    @IBAction func noButtonAction() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    @IBAction func yesButtonAction() {
        guard var currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }

        private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage(),
        question = model.text
        let questionNumber = "\(currentQuestionIndex + 1)/\(questionsAmount)"
        
        let result = QuizStepViewModel(
            image: image,
            question: question,
            questionNumber: questionNumber
        )
        return result
    }
        
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        if let firstQuestion = self.questionFactory.requestNextQuestion() {
            self.currentQuestion = firstQuestion
            let viewModel = self.convert(model: firstQuestion)
            
            self.show(quiz: viewModel)
        }
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {
            rightAnswers += 1
        }
        imageView.layer.borderColor = UIColor(named: isCorrect ? "ypGreen" : "ypRed")!.cgColor
        showNextQuestionOrResults()
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = rightAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            "Вы ответили на \(rightAnswers) из 10, попробуйте еще раз!"
            quizCount += 1
            let viewModel = convert(model: QuizStepViewModel(image: UIImage(), question: "", questionNumber: ""))
            show(quiz: viewModel)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                guard currentQuestionIndex < questionsAmount - 1 else { return }
                currentQuestionIndex += 1
                if let question = questionFactory.requestNextQuestion(){
                    currentQuestion = question
                    let viewModel = convert(model: question)
                    
                    show(quiz: viewModel)

                }
            }
        }
    }
    private func convert(model: QuizStepViewModel) -> QuizResultsViewModel {
        let title = "Этот раунд окончен!"
        let buttonText = "Сыграть еще раз"
        let totalQuestions = questionsAmount
        let gameResult = "\(rightAnswers)/\(totalQuestions)"
        if rightAnswers > maxRightAnswers {
            maxRightAnswers = rightAnswers
            allRightAnswers += rightAnswers
        }
        
        if quizCount == 0 {
            allAnswers = totalQuestions + 1
        } else {
            allAnswers = totalQuestions * quizCount
        }
        
        let quizCount = quizCount
        let record = maxRightAnswers
        let avgAccuracy = Int(round(Float(allRightAnswers) / Float(allAnswers) * 100))
        let text = """
                   Ваш результат: \(gameResult)
                   Количество сыгранных квизов: \(quizCount)
                   Рекорд: \(record)
                   Средняя точность: \(avgAccuracy)%
                   """
        
        let result = QuizResultsViewModel(
            title: title,
            text: text,
            buttonText: buttonText)
        return result
    }

    private func restartQuiz() {
        currentQuestionIndex = 0
        rightAnswers = 0
        if let nextQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = nextQuestion
            let viewModelStart = convert(model: nextQuestion)

            show(quiz: viewModelStart)
        }
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                message: result.text,
                preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: {_ in self.restartQuiz() })
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

