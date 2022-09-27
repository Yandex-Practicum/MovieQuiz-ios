import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion (
          image: "The Godfather",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: true),
        
        QuizQuestion (
          image: "The Dark Knight",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: true),
        
        QuizQuestion (
          image: "Kill Bill",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: true),
        
        QuizQuestion (
          image: "The Avengers",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: true),
        
        QuizQuestion (
          image: "Deadpool",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: true),
        
        QuizQuestion (
          image: "The Green Knight",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: true),
        
        QuizQuestion (
          image: "Old",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: false),
        
        QuizQuestion (
          image: "The Ice Age Adventures of Buck Wild",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: false),
        
        QuizQuestion (
          image: "Tesla",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: false),
        
        QuizQuestion (
          image: "Vivarium",
          text: "Рейтинг этого фильма больше чем 6?",
          correctAnswer: false)
    ]

    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    
    private var currentQuestionIndex: Int = 0
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if questions[currentQuestionIndex].correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if !questions[currentQuestionIndex].correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
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
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = convert(model: questions[currentQuestionIndex]).questionNumber
        textLabel.text = convert(model: questions[currentQuestionIndex]).question
        imageView.image = convert(model: questions[currentQuestionIndex]).image
    }

    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
      }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 {
          let text = "Ваш результат: \(correctAnswers) из 10"
          let viewModel = QuizResultsViewModel(
                      title: "Этот раунд окончен!",
                      text: text,
                      buttonText: "Сыграть ещё раз")
          imageView.layer.borderWidth = 0
          show(quiz: viewModel)
      } else {
          currentQuestionIndex += 1
          
          imageView.layer.borderWidth = 0
          
          let nextQuestion = questions[currentQuestionIndex]
          let viewModel = convert(model: nextQuestion)
                  
          show(quiz: viewModel)
      }
    }
    
    private var correctAnswers: Int = 0
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
                correctAnswers += 1
            }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter (deadline: .now() + 1.0) { //in
            self.showNextQuestionOrResults()
        }
    }
        

    
}
