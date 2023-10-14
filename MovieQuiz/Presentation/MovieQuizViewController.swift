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
        QuizQuestion(image: "Lords of the Lockerroom", text: questionLabel, isCorrectAnswer: true),
        QuizQuestion(image: "The Room", text: questionLabel, isCorrectAnswer: false),
        QuizQuestion(image: "Schastlivyy konets", text: questionLabel, isCorrectAnswer: false),
        QuizQuestion(image: "Sharknado", text: questionLabel, isCorrectAnswer: false),
        
    ]
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private lazy var questionsCount = questions.count

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toggleButtonsState(isEnabled: true)
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 20
        
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        
        if (currentQuestion.isCorrectAnswer) {
            showAnswerResult(isCorrect: true)
            correctAnswers += 1;
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    
    @IBAction private func noButtonCicked(_ sender: UIButton) {
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
        questionTextLabel.text = step.question
        counterLabel.text = step.questionNumber
        posterImageView.image = step.image
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
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.borderWidth = 8
        posterImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.posterImageView.layer.borderWidth = 0
            self.toggleButtonsState(isEnabled: false);
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        toggleButtonsState(isEnabled: true)
        
        if currentQuestionIndex == questions.count - 1 {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: "Ваш результат: \(correctAnswers)/\(questionsCount)",
                buttonText: "Сыграть ещё раз"
            )
            showQuizResult(quiz: viewModel)
        } else {
            currentQuestionIndex += 1;
            
            let nextQuestion = questions[currentQuestionIndex]
            show(quiz: convert(model: nextQuestion))
        }
    }
    
    private func toggleButtonsState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled;
        noButton.isEnabled = isEnabled;
    }
 }
