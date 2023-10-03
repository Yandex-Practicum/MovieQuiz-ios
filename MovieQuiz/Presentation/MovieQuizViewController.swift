import UIKit

struct QuizQuestion {
    let image: String
    let text: String
    let isCorrectAnswer: Bool
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

let questionLabel = "Рейтинг этого фильма больше чем 5?"

final class MovieQuizViewController: UIViewController {
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Green Elephant", text: questionLabel, isCorrectAnswer: true),
        QuizQuestion(image: "Pyat butylok vodki", text: questionLabel, isCorrectAnswer: true),
        QuizQuestion(image: "Vase de noces", text: questionLabel, isCorrectAnswer: false),
        QuizQuestion(image: "Srpski film", text: questionLabel, isCorrectAnswer: true),
        QuizQuestion(image: "Neposredstvenno Kakha", text: questionLabel, isCorrectAnswer: false),
        QuizQuestion(image: "The Best Movie", text: questionLabel, isCorrectAnswer: false),
    ]
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        
        if (currentQuestion.isCorrectAnswer) {
            showAnswerResult(isCorrect: true)
            correctAnswers += 1;
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction func noButtonCicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        
        if (currentQuestion.isCorrectAnswer) {
            showAnswerResult(isCorrect: false)
        } else {
            showAnswerResult(isCorrect: true)
            correctAnswers += 1;
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel.init(
            image: UIImage.init(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber:  "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        
        return quizStepViewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    private func showQuizResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title, message: result.text, preferredStyle: .alert
        )
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            self.show(quiz: self.convert(model: firstQuestion))
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 6
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: "Ваш результат: \(correctAnswers)/6",
                buttonText: "Сыграть ещё раз"
            )
            showQuizResult(quiz: viewModel)
        } else {
            currentQuestionIndex += 1;
            
            let nextQuestion = questions[currentQuestionIndex]
            show(quiz: convert(model: nextQuestion))
        }
    }
 }
