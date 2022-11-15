import UIKit

final class MovieQuizViewController: UIViewController {
    
    struct QuizStepViewModel{
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    struct QuizResultsViewModel{
        let title: String
        let text: String
        let buttonText: String
    }
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
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
                     correctAnswer: false)
    ]
    
    
    // MARK: - Lifecycle
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        show(quiz: currentQuestionIndex)

    }
    
    private func show(quiz questinIndex: Int) {
        let currentQuestion = questions[currentQuestionIndex]
        let quizStepViewModel = convert(model: currentQuestion)
        imageView.image = quizStepViewModel.image
        textLabel.text = quizStepViewModel.question
        counterLabel.text = quizStepViewModel.questionNumber
        
    }
    
    private func showResult() {
        let alert = UIAlertController(title: "Этот раунд окончен",
                                      message: "Ваш результат: " + "\(correctAnswers)/\(questions.count)",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default, handler: { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.show(quiz: self.currentQuestionIndex)
            
        })
    
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func showAnswerResult(isCorrect: Bool){
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 6 // толщина рамки
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else{
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        
        }
 

    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            showResult()
            
        } else {
            currentQuestionIndex += 1
            show(quiz: currentQuestionIndex)
            
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: correctAnswer == false)
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: correctAnswer == true)
    }
    
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
