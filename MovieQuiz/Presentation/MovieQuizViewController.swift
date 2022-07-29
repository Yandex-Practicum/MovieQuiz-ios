import UIKit

final class MovieQuizViewController: UIViewController {
    private var state = GameState()
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state.questions = getQuestionsMock()
        displayQuestion()
    }
    
    private func displayQuestion() {
        let viewModel = QuizeStepViewModel(
            model: state.currentQuestion,
            number: "\(state.currentQuestionNumber)/\(state.totalQuestions)")
        
        show(quize: viewModel)
    }
    
    private func show(quize step: QuizeStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        processAnswer(answer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        processAnswer(answer: false)
    }

    private func processAnswer(answer: Bool) {
        let isCorrect = answer == state.currentQuestion.correctAnswer
        state.currentScore += isCorrect ? 1 : 0
        
        showAnswerResult(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    
    private func showNextQuestionOrResults() {
        if state.currentQuestionIndex >= state.totalQuestions - 1 {
            endGameSession()
            
            show(quize: QuizeResultViewModel(state: state))
            
            state.currentScore = 0
            state.currentQuestionIndex = 0
        } else {
            state.currentQuestionIndex += 1
            displayQuestion()
        }
    }
    
    private func endGameSession() {
        state.averageAnswerAccuracy = (state.averageAnswerAccuracy * Double(state.totalGamesCount) + Double(state.currentScore) / Double(state.totalQuestions)) / Double(state.totalGamesCount + 1)
        
        if state.currentScore > state.bestScore {
            state.bestScore = state.currentScore
            state.bestScoreDate = Date()
        }
        
        state.totalGamesCount += 1
    }
    
    private func show(quize result: QuizeResultViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {
            _ in
            self.displayQuestion()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}

// MARK: - Models
extension MovieQuizViewController {
    struct QuizeQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct GameState {
        var questions = [QuizeQuestion]()
        var currentQuestionIndex: Int = 0
        var currentScore: Int = 0
        
        var bestScore: Int = 0
        var bestScoreDate: Date = .distantPast
        
        var totalGamesCount: Int = 0
        var averageAnswerAccuracy: Double = 0.0
        
        var totalQuestions: Int { questions.count }
        var currentQuestion: QuizeQuestion { questions[currentQuestionIndex] }
        var currentQuestionNumber: Int { currentQuestionIndex + 1 }
        
        var bestGameDateString: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy HH:mm"

            return dateFormatter.string(from: bestScoreDate)
        }
    }
    
    struct QuizeStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
        
        init(model: QuizeQuestion, number: String) {
            image = UIImage(named: model.image) ?? .remove
            question = model.text
            questionNumber = number
        }
    }
    
    struct QuizeResultViewModel {
        let title: String
        let text: String
        let buttonText: String
        
        init (state: GameState) {
            title = "Этот раунд окончен!"
            buttonText = "Сыграть еще раз"
            
            let totalQuestions = state.questions.count
            let accuracy = String(format: "%.2f", state.averageAnswerAccuracy * 100)
            
            text = """
            Ваш результат: \(state.currentScore)/\(totalQuestions)
            Количество сыграных квизов: \(state.totalGamesCount)
            Рекорд: \(state.bestScore)/\(totalQuestions) (\(state.bestGameDateString))
            Средняя точность: \(accuracy)%
            """
        }
    }
}


// MARK: - Mock Data
extension MovieQuizViewController {
    func getQuestionsMock() -> [QuizeQuestion] {
        let data = [
            QuizeQuestion(image: "The Godfather",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true), // Настоящий рейтинг: 9,2
            QuizeQuestion(image: "The Dark Knight",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true), // Настоящий рейтинг: 9
            QuizeQuestion(image: "Kill Bill",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true), // Настоящий рейтинг: 8,1
            QuizeQuestion(image: "The Avengers",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true), // Настоящий рейтинг: 8
            QuizeQuestion(image: "Deadpool",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true), // Настоящий рейтинг: 8
            QuizeQuestion(image: "The Green Knight",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: true), // Настоящий рейтинг: 6,6
            QuizeQuestion(image: "Old",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: false), // Настоящий рейтинг: 5,8
            QuizeQuestion(image: "The Ice Age Adventures of Buck Wild",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: false), // Настоящий рейтинг: 4,3
            QuizeQuestion(image: "Tesla",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: false), // Настоящий рейтинг: 5,1
            QuizeQuestion(image: "Vivarium",
                          text: "Рейтинг этого фильма больше чем 6?",
                          correctAnswer: false), // Настоящий рейтинг: 5,8
        ]
        
        return data
    }
}

// MARK: - StatusBar style
extension MovieQuizViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}
