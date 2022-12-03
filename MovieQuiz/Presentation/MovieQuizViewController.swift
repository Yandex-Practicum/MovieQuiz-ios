import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    
    private var correctAnswer: Int = 0
    
    private let questionsAmount: Int = 10
    private let questionFactory: QuestionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            show(quiz: viewModel)
        }
    }
    // here we fill our picture, text and counter with data
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
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
            if let firstQuestion = self.questionFactory.requestNextQuestion() {
                self.currentQuestion = firstQuestion
                let viewModel = self.convert(model: firstQuestion)
                
                self.show(quiz: viewModel)
            }
        }
        // add buttons to alert
        alert.addAction(action)

        // show popup window
        self.present(alert, animated: true, completion: nil)

    }
    
    // Converting converting data from one format to another
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
        
        yesButton.isEnabled = false
        noButton.isEnabled = false

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    // MARK: - Action
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer )
        
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer )
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questionsAmount - 1 {
          let text = correctAnswer == questionsAmount ?
          "Поздравляем, Вы ответили на 10 из 10!" :
          "Вы ответили на \(correctAnswer) из 10, попробуйте ещё раз!"
          let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
          // at the end of the quiz, remove the frame and color
          imageView.layer.borderColor = nil
          imageView.layer.borderWidth = 0
        show(quiz: viewModel)
      } else {
        currentQuestionIndex += 1
        // when switching to the next question, remove the frame and color
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
          if let nextQuestion = questionFactory.requestNextQuestion() {
              currentQuestion = nextQuestion
              let viewModel = convert(model: nextQuestion)
              
              show(quiz: viewModel)
          }
      }
    }
}
