import UIKit


struct ViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
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

struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}


final class MovieQuizViewController: UIViewController {
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
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
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentQuestion()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        handleUserAnswer(answer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        handleUserAnswer(answer: true)
    }
    
    private func handleUserAnswer(answer: Bool) {
        let question = questions[currentQuestionIndex]
        let isCorrect = question.correctAnswer == answer

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor =  isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        
        self.disableOrEnableButtons(isEnabled: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.disableOrEnableButtons(isEnabled: true)
        }
    }
    
    private func showCurrentQuestion() {
        let step = convert(model: questions[currentQuestionIndex])
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let alert = UIAlertController(title: "Игра окончена.",
                                          message: "Ваш результат: \(correctAnswers)/\(questions.count).",
                                          preferredStyle: .alert)

            let action = UIAlertAction(title: "Сыграем еще раз?", style: .default) { [weak self] _ in
                self?.correctAnswers = 0
                self?.currentQuestionIndex = 0
                self?.showCurrentQuestion()
            }

            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        } else {
            currentQuestionIndex += 1
            showCurrentQuestion()
        }
    }
    
    private func disableOrEnableButtons(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questions.count)"
        )
    }
}
