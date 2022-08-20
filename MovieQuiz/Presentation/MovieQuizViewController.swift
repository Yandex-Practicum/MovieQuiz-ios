// my project

import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // MARK: - Properties

    private let questions: [QuizQuestion] = DataSource.mockQuestions
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion? /* удалить, если не используем*/
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
    }
    // MARK: - Actions
    @IBAction private func noButton(_ sender: UIButton) {
        showAnswerResult(answer: false)
    //question: questions[currentQuestionIndex])
        
    }
    
    @IBAction private func yesButton(_ sender: UIButton) {
       showAnswerResult(answer: true)
    //question: questions[currentQuestionIndex])
    }
    
    //_MARK: - Logic
    
    private func show(quiz step: QuizStepViewModel) { // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.layer.borderWidth = 0
        imageView.image = step.image
            questionLabel.text = step.question
            counterLabel.text = step.questionNumber
        }
    
    private func showQuestion() {
        /// Установили текущий вопрос. Так как у нас квиз начинается с 1го вопроса,
        /// то и берем из массива вопросов 1й элемент
        currentQuestion = questions[safe: currentQuestionIndex] // метод лежит в Array+Extensions
        
        guard let currentQuestion = currentQuestion else { return }
        let questionViewModel = convert(model: currentQuestion)
        show(quiz: questionViewModel)
    }
    
    private func showAnswerResult(answer: Bool)
        {
            guard let currentQuestion = currentQuestion else { return }
            
            let isCorrect = (answer == currentQuestion.correctAnswer)
            let greenColor = UIColor(named: "green") ?? .green
            let redColor = UIColor(named: "red") ?? .red
            let borderColor = isCorrect ? UIColor(named: "green")! : UIColor(named: "red")
            
            imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 // толщина рамки
            imageView.layer.borderColor = UIColor(named:"green")!.cgColor // делаем рамку зеленой
            imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.showNextQuestionOrResults()
              //  self.showNextQuestionOrResults()  // вызов
            }
        }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
          print("Пора показать результат")
        // показать результат квиза
      } else {
        currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1; таким образом мы сможем получить следующий урок
       showQuestion()
          // показать следующий вопрос
      }
    }
    
     func convert(model: QuizQuestion) -> QuizStepViewModel { //код конвертации
            return QuizStepViewModel(
                image: UIImage(named: model.image) ?? .remove,
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
            )
        }

    enum DataSource {
            static let mockQuestions: [QuizQuestion] = [
                QuizQuestion(
                    image: "Deadpool",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: true),
                
                QuizQuestion(
                    image: "The Dark Knight",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: true),
        
                QuizQuestion(
                    image: "The Godfather",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: true),
        
                QuizQuestion(
                    image: "Kill Bill",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: true),
        
                QuizQuestion(
                    image: "The Avengers",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: true),
        
                QuizQuestion(
                    image: "The Green Knight",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: true),
        
                QuizQuestion(
                    image: "Old",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: false),
        
                QuizQuestion(
                    image: "The Ice Age Adventures of Buck Wild",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: false),
        
                QuizQuestion(
                    image: "Tesla",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: false),
        
                QuizQuestion(
                    image: "Vivarium",
                    text: "Рейтинг этого фильма меньше, чем 6?",
                    correctAnswer: false)]
                }
}
