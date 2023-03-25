import UIKit

final class MovieQuizViewController: UIViewController {
    
    private struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
        
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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

    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var gamesPlayed: Int = 0
    private var record: Int = 0
    private var avgPerformance: Float = 0.0
    private var allTimeCorrectAnswers: Int = 0
    
    private func convertQuestion(model: QuizQuestion) -> QuizStepViewModel {
        
        return QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
        
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convertQuestion(model: firstQuestion)
            self.show(quiz: viewModel)
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func checkAnswer(answerGiven: Bool) -> Bool {
        var result: Bool = false
        let currentQuestion = questions[currentQuestionIndex]
        if answerGiven == currentQuestion.correctAnswer {
            result = true
        }
        return result
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func generateResult() -> QuizResultsViewModel {
        
        allTimeCorrectAnswers += correctAnswers
        gamesPlayed += 1
        
        if correctAnswers > record {
            record = correctAnswers
        }
            
        avgPerformance = Float(allTimeCorrectAnswers / gamesPlayed * 10)
        
        return QuizResultsViewModel(title: "Этот раунд окончен!",
                                    text: "Ваш результат: \(correctAnswers)/10 \n Кол-во сыгранных квизов: \(gamesPlayed) \n Рекорд: \(record) \n Средняя точность: \(avgPerformance)%",
                                    buttonText: "Сыграть еще раз")
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questions.count - 1 {
            
            show(quiz: generateResult())

        } else {
            currentQuestionIndex += 1
            let currentQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convertQuestion(model: currentQuestion)
            show(quiz: viewModel)
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton!) {
        var result = checkAnswer(answerGiven: false)
        showAnswerResult(isCorrect: result)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton!) {
        
        var result = checkAnswer(answerGiven: true)
        showAnswerResult(isCorrect: result)
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
}


