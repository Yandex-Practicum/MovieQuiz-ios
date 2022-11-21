import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // для состояния "Вопрос задан"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
        
    }
    
    // для состояния "Результат квиза"
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     text: "Рейтинг этого фильма больше чем 6?",
                     correctAnswer: false),
    ]
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startQuiz(with: 0)
        
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count-1 {
            // показать результат квиза
            let text = "Ваш результат: \(correctAnswers) из \(questions.count)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
            startQuiz(with: 0)
            
        } else {
            imageView.layer.borderWidth = 0
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1, т.о. мы сможем получить следующий урок
            let currentQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: currentQuestion)
            show(quiz: viewModel)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        // здесь мы показываем верно или нет ответил пользователь
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
        
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default,
            handler: { _ in self.startQuiz(with: 0) })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    private func startQuiz(with index: Int) {
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestion)
        currentQuestionIndex = index
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
        correctAnswers = 0
        show(quiz: viewModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")// высчитываем номер вопроса// берём текст вопроса
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
}

