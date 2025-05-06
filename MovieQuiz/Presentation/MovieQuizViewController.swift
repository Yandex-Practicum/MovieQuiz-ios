import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionCountLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var quizQuestion: UILabel!
    
    private var questionIndex: Int = 0
    private var questions: [QuizQuestion] = []
    
    private var correctAnswers: Int = 0
    private var totalQuizzesPlayed: Int = 0
    private var highestScore: Int = 0
    private var highestScoreDate: Date?
    
    struct QuizQuestion {
        var imageName: String
        var question: String
        var answer: Bool
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestions()
        displayCurrentQuestion()
    }
    
    private func setupQuestions() {
        questions = [
            QuizQuestion (imageName: "The Godfather", question: "Рейтинг этого фильма больше чем 6?", answer: true),
            QuizQuestion (imageName: "The Dark Knight", question: "Рейтинг этого фильма больше чем 6?", answer: true),
            QuizQuestion (imageName: "Kill Bill", question: "Рейтинг этого фильма больше чем 6?", answer: true),
            QuizQuestion (imageName: "The Avengers", question: "Рейтинг этого фильма больше чем 6?", answer: true),
            QuizQuestion (imageName: "Deadpool", question: "Рейтинг этого фильма больше чем 6?", answer: true),
            QuizQuestion (imageName: "The Green Knight", question: "Рейтинг этого фильма больше чем 6?", answer: true),
            QuizQuestion (imageName: "Old", question: "Рейтинг этого фильма больше чем 6?", answer: false),
            QuizQuestion (imageName: "The Ice Age Adventures of Buck Wild", question: "Рейтинг этого фильма больше чем 6?", answer: false),
            QuizQuestion (imageName: "Tesla", question: "Рейтинг этого фильма больше чем 6?", answer: false),
            QuizQuestion (imageName: "Vivarium", question: "Рейтинг этого фильма больше чем 6?", answer: false)
        ]
    }
    
    @IBAction func yesButton(_ sender: Any) {
        checkAnswer(userAnswer: true)
    }
    
    @IBAction func noButton(_ sender: Any) {
        checkAnswer(userAnswer: false)
    }
    
    private func checkAnswer(userAnswer: Bool) {
        let answer = questions[questionIndex].answer
        if userAnswer == answer {
            image.layer.borderColor = UIColor(named: "YP green")?.cgColor
            correctAnswers += 1
        }  else {
            image.layer.borderColor = UIColor(named: "YP red")?.cgColor
        }
        image.layer.borderWidth = 8
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestion()
        }
    }
    
    private func showNextQuestion() {
        image.layer.borderWidth = 0
        
        questionIndex += 1
        if questionIndex < questions.count {
            displayCurrentQuestion()
        } else {
            showCompletionAlert()
        }
}
    
    private func displayCurrentQuestion() {
        let currentQuestion = questions[questionIndex]
        quizQuestion.text = currentQuestion.question
        image.image = UIImage(named: currentQuestion.imageName)
        questionCountLabel.text = "\(questionIndex + 1)/\(questions.count)"
            }
    

   private func showCompletionAlert() {
        totalQuizzesPlayed += 1
        if correctAnswers > highestScore {
           highestScore = correctAnswers
           highestScoreDate = Date()
       }
       
       let accuracy = Double(correctAnswers) / Double(questions.count) * 100
       let dateFormatter = DateFormatter()
       dateFormatter.dateStyle = .short
       dateFormatter.timeStyle = .short
       let scoreDateString = highestScoreDate != nil ? dateFormatter.string(from: highestScoreDate!) : "N/A"

       let alert = UIAlertController(
           title: "Этот раунд окончен",
           message: """
           Ваш результат: \(correctAnswers) из \(questions.count)
           Количество сыгранных квизов: \(totalQuizzesPlayed)
           Рекорд: \(highestScore) (дата: \(scoreDateString))
           Средняя точность: \(accuracy)%
           """,
           preferredStyle: .alert
       )

       alert.addAction(UIAlertAction(title: "Сыграть еще раз", style: .default) { _ in
           self.restartGame()
       })


       present(alert, animated: true, completion: nil)
   }

   private func restartGame() {
       questionIndex = 0
       correctAnswers = 0
       displayCurrentQuestion()
   }
}


/*
private struct TheGodfather {
    var realRating: Double = 9.2
    var question: String
    init(quizRating: Double) {
        question = "Рейтинг этого фильма больше чем \(quizRating)?"
    }
}
 
 private var quizRating: Double = 6
*/



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
