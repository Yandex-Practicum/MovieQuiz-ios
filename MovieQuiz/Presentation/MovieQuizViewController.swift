import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: ViewModels
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 9,2
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 9
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 8,1
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 8
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true), // Настоящий рейтинг: 8
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),  // Настоящий рейтинг: 6,6
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),  // Настоящий рейтинг: 5,8
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),  // Настоящий рейтинг: 4,3
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),  // Настоящий рейтинг: 5,1
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)  // Настоящий рейтинг 5,8
    ]
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var noAnswerButton: UIButton!
    @IBOutlet weak var yesAnswerButton: UIButton!
    
    private var currentQuestionIndex: Int = 0 // индекс нашего вопроса
    private var counterCorrectAnswers: Int = 0 // счетчик правильных ответов
    private var numberOfQuizGames: Int = 0 // количетсво сыгранных квизов
    private var recordCorrectAnswers: Int = 0 // рекорд правильных овтетов
    private var recordDate = Date() // дата рекорда
    private var averageAccuracy = 0.0 // среднее кол-во угаданных ответов в %
    private var numberOfQuizQuestion: Int = 10 // максимальное количество вопросов ответов
    private var allCorrectAnswers: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == true)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        UIView.animate(withDuration: 0.1) {
            self.textLabel.text = step.question
            self.counterLabel.text = step.questionNumber
            self.imageView.image = step.image
        }
    }

    // показываем алерт
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText,
                                   style: .default,
                                   handler: {
                                    _ in self.restart()
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? .remove,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(numberOfQuizQuestion)")
    }
    
    // перезапуск игры
    private func restart() {
        counterCorrectAnswers = 0
        currentQuestionIndex = 0
        setupViewModel()
    }
    
    // установка вьюшки
    private func setupViewModel() {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        let viewModel = convert(model: questions[currentQuestionIndex])
        show(quiz: viewModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            counterCorrectAnswers += 1
        }
        
        yesAnswerButton.isEnabled = false
        noAnswerButton.isEnabled = false
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        yesAnswerButton.isEnabled = true
        noAnswerButton.isEnabled = true
        if currentQuestionIndex == questions.count - 1 {
            allCorrectAnswers += counterCorrectAnswers
            numberOfQuizGames += 1
            let resultQuiz = getResultQuiz()
            show(quiz: resultQuiz)
        } else {
            currentQuestionIndex += 1
            setupViewModel()
        }
    }
    
    private func getResultQuiz() -> QuizResultsViewModel {
        var title = "Игра окончена!"
        if counterCorrectAnswers >= recordCorrectAnswers {
            title = "Поздравляем! Новый рекорд!"
            recordCorrectAnswers = counterCorrectAnswers
            recordDate.dateTimeString
        }
        
        if counterCorrectAnswers == numberOfQuizGames {
            title = "Поздравляем! Это лучший результат"
        }
        averageAccuracy = Double(allCorrectAnswers * 100) / Double(numberOfQuizQuestion * numberOfQuizGames)
        let resultQuiz = QuizResultsViewModel(title: title,
                                             text: """
                                             Ваш результат: \(counterCorrectAnswers)/\(numberOfQuizQuestion)
                                             Количество сыгранных квизов: \(numberOfQuizGames)
                                             Рекорд: \(recordCorrectAnswers)/\(numberOfQuizQuestion) \(recordDate.dateTimeString)
                                             Средняя точность: \(String(format: "%.02f", averageAccuracy))%
                                             """,
                                             buttonText: "Новая игра")
        return resultQuiz
    }
    
    // статусбар с белым контентом
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
}
