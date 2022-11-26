import UIKit

final class MovieQuizViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var textLabel: UILabel!
  @IBOutlet private weak var counterLabel: UILabel!
  
  @IBOutlet weak var yesButton: UIButton!
  @IBOutlet weak var noButton: UIButton!
  @IBOutlet weak var questionLabel: UILabel!
  
  // MARK: - Properties
  private var currentQuestionIndex: Int = 0
  private var correctAnswers: Int = 0
  private let questions: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
    QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
  ]
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textLabel.font = UIFont.ysDisplayBold.withSize(50)
    counterLabel.font = UIFont.ysDisplayMedium
    questionLabel.font = UIFont.ysDisplayMedium
    yesButton.titleLabel?.font = UIFont.ysDisplayMedium
    noButton.titleLabel?.font = UIFont.ysDisplayMedium
    
    show(quiz: getNextQuestion())
  }
  
  // MARK: - Actions
  @IBAction private func noButtonClicked(_ sender: UIButton) {
    let currentQuestion = questions[currentQuestionIndex]
    let isCorrect = currentQuestion.correctAnswer == false
    showAnswerResult(isCorrect: isCorrect)
  }
  
  @IBAction private func yesButtonClicked(_ sender: UIButton) {
    let currentQuestion = questions[currentQuestionIndex]
    let isCorrect = currentQuestion.correctAnswer == true
    showAnswerResult(isCorrect: isCorrect)
  }
  
  private func show(quiz step: QuizStepViewModel) {
    imageView.layer.borderWidth = 0
    imageView.image = step.image
    textLabel.text = step.question
    counterLabel.text = step.questionNumber
  }
  
  private func show(quiz result: QuizResultsViewModel) {
    
    let alert = UIAlertController(
      title: result.title,
      message: result.text,
      preferredStyle: .alert)
    
    let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
      self.currentQuestionIndex = 0
      self.correctAnswers = 0
      self.show(quiz: self.getNextQuestion())
    }
    
    alert.addAction(action)
    
    self.present(alert, animated: true, completion: nil)
    
  }
  
  private func showNextQuestionOrResults() {
    if currentQuestionIndex == questions.count - 1 {
      let text = "Ваш результат: \(correctAnswers) из 10"
      let viewModel = QuizResultsViewModel(
        title: "Этот раунд окончен!",
        text: text,
        buttonText: "Сыграть ещё раз")
      show(quiz: viewModel)
    } else {
      currentQuestionIndex += 1
      self.show(quiz: self.getNextQuestion())
    }
    setButtonsAvailability(true)
  }
  
  private func showAnswerResult(isCorrect: Bool) {
    imageView.layer.masksToBounds = true
    imageView.layer.borderWidth = 8
    imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    imageView.layer.cornerRadius = 20
    
    if isCorrect {
      correctAnswers += 1
    }
    setButtonsAvailability(false)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.showNextQuestionOrResults()
    }
  }
 

  private func getNextQuestion() -> QuizStepViewModel {
    let currentQuestion = questions[currentQuestionIndex]
    let quizStepVM = convert(model: currentQuestion)
    return quizStepVM
  }
  
  private func convert(model: QuizQuestion) -> QuizStepViewModel {
    return QuizStepViewModel(
      image: UIImage(named: model.image) ?? UIImage(),
      question: model.text,
      questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
    )
  }
  
  private func setButtonsAvailability(_ value: Bool) {
    yesButton.isEnabled = value
    noButton.isEnabled = value
  }
  
}
// MARK: - Model
struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}

// MARK: - ViewModel
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

