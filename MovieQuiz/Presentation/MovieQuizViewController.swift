import UIKit

final class MovieQuizViewController: UIViewController {

    
    @IBAction private func noButton(_ sender: UIButton) {
        showAnswerResult(isCorrect: false == questions[currentQuestionIndex].correctAnswer)
    }
    @IBAction private func yesButton(_ sender: UIButton) {
        let answer = true
        let currentQuestion = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: answer == currentQuestion)
    }
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textlabel: UILabel!
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion: QuizQuestion = questions[currentQuestionIndex]
        let quizStepViewModelReturned: QuizStepViewModel = convert(model: currentQuestion)
        show(quiz: quizStepViewModelReturned)
    }
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textlabel.text = step.question
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
        title: result.title,
        message: result.text,
        preferredStyle: .alert)
 
        let action = UIAlertAction(
        title: result.buttonText,
        style: .default,
        handler: { _ in
         self.currentQuestionIndex = 0
            self.correctAnswers = 0
         let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
     })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
     return QuizStepViewModel(
        image: UIImage(named: model.image) ?? UIImage(),
        question: model.text,
        questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
      }
   private var correctAnswers: Int = 0
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect == true {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor : UIColor.red.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {  // запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция showNextQuestionOrResults()
        
            self.showNextQuestionOrResults()
        }
}
  
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            imageView.layer.borderWidth = 0
            imageView.layer.cornerRadius = 0
            let QuizStep: QuizResultsViewModel = QuizResultsViewModel(title: "Сыграть ещё раз?", text: "Правильных ответов \(correctAnswers)", buttonText: "OK")
           show(quiz: QuizStep)
        } else {
            imageView.layer.borderWidth = 0
            imageView.layer.cornerRadius = 0
            currentQuestionIndex += 1
            viewDidLoad()
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

    struct QuizQuestion {
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
        correctAnswer: false),
    ]
    
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
