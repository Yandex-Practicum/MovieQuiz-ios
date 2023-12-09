import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var questionCountLabel: UILabel!
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    
    private var correctCount = 0
    
    private var currentQuestionIndex = 0
    
    private var currentQuestion: QuizQuestion {
        return questions[currentQuestionIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieImage.layer.cornerRadius = 20
    }
    
    @IBAction private func onTapNo() {
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    @IBAction private func onTapYes() {
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    private func showQuestion(quiz step: QuizStepViewModel) {
        movieImage.image = step.image
        questionLabel.text = step.question
        questionCountLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    private func triggerHapticFeedback(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(notificationType)
        }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctCount += 1;
            triggerHapticFeedback(.success)
        } else {
            triggerHapticFeedback(.error)
        }
        paintBorder(isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func paintBorder(_ isCorrect: Bool) {
        let layer = movieImage.layer
        layer.masksToBounds = true
        layer.borderWidth = 8
        layer.borderColor = (isCorrect ? UIColor.greenBorder : UIColor.redBorder)?.cgColor
        layer.cornerRadius = 20
    }
    
    private func showNextQuestionOrResults() {
        movieImage.layer.borderWidth = 0 // Убрать border
        if currentQuestionIndex == questions.count - 1 {
            showResults(
                QuizResultsViewModel(
                title: "Раунд окончен!",
                text: "Ваш результат: \(correctCount)/\(questions.count)",
                buttonText: "Сыграть еще раз")
            )
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            showQuestion(quiz: viewModel)
        }
    }
    
    
    private func showResults(_ result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctCount = 0
            
            let firstQuestion = questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.showQuestion(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}


struct QuizQuestion {
    // строка с названием фильма,
    // совпадает с названием картинки афиши фильма в Assets
    let image: String
    // строка с вопросом о рейтинге фильма
    let text: String
    // булевое значение (true, false), правильный ответ на вопрос
    let correctAnswer: Bool
}

// вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
    // картинка с афишей фильма с типом UIImage
    let image: UIImage
    // вопрос о рейтинге квиза
    let question: String
    // строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
    // строка с заголовком алерта
    let title: String
    // строка с текстом о количестве набранных очков
    let text: String
    // текст для кнопки алерта
    let buttonText: String
}

private let questions: [QuizQuestion] = [
    QuizQuestion(
        image: "The Godfather",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "The Dark Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "Kill Bill",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "The Avengers",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "Deadpool",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "The Green Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: true),
    QuizQuestion(
        image: "Old",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion(
        image: "The Ice Age Adventures of Buck Wild",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion(
        image: "Tesla",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false),
    QuizQuestion(
        image: "Vivarium",
        text: "Рейтинг этого фильма больше чем 6?",
        correctAnswer: false)
]
