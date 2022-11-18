import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    private var currentQuestionIndex: Int = 0
    private var correctAnswer: Int = 0
    var appMode = 0
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        let displays = convert(model: currentQuestion)
        show(quiz: displays)
    }
    // for the status "Question asked"
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
        
    }
    // here we fill our picture, text and counter with data
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // for the state "Result of the quiz"
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    private func show(quiz result: QuizResultsViewModel) {
        //here we show the result of passing the quiz
        // create popup objects
        let alert = UIAlertController(title: result.text, // popup title
                                      message: result.text, // popup text
                                      preferredStyle: .alert) // alert

        // create action buttons for it
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            // we reset the counter of correct answers
                self.correctAnswer = 0
            
            // re-show the first question
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        // add buttons to alert
        alert.addAction(action)

        // show popup window
        self.present(alert, animated: true, completion: nil)

    }
    
    // moc - data
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    //  10 questions of our quiz
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
    // Converting converting data from one format to another
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    // response result display state
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        // indicates the correctness of the answer, the width of the sides, shows a red or green frame
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    // MARK: - Action
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer )
        
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer )
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 {
          let text = "Ваш результат: \(correctAnswer) из 10"
          let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
          yesButton.isEnabled = true
          noButton.isEnabled = true
          // at the end of the quiz, remove the frame and color
          imageView.layer.borderColor = nil
          imageView.layer.borderWidth = 0
        show(quiz: viewModel)
      } else {
        currentQuestionIndex += 1
          yesButton.isEnabled = true
          noButton.isEnabled = true
        // when switching to the next question, remove the frame and color
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
        let nextQuestion = questions[currentQuestionIndex]
        let vieModel = convert(model: nextQuestion)
          
        show(quiz: vieModel)
      }
    }
}
