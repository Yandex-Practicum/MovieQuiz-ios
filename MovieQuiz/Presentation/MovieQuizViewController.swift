import UIKit

final class MovieQuizViewController: UIViewController {

    @IBAction private func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == questions[currentQuestionIndex].correctAnswer)
    }
    @IBOutlet private weak var textLabel: UILabel!
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == questions[currentQuestionIndex].correctAnswer)
    }
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    struct QuizStepViewModel {     // Структура для состояния "Вопрос задан"
      let image: UIImage
      let question: String
      let questionNumber: String
    }

    struct QuizResultsViewModel {  // Структура для состояния "Результат"
      let title: String
      let text: String
      let buttonText: String
    }

    struct QuizQuestion {     // Структура для Вопроса
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel { //подготавливаю структуру перед выводом
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }

    private func show(quiz step: QuizStepViewModel) {   // Показываю вопрос на экране
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
      if currentQuestionIndex == questions.count - 1 {
        let viewModel = QuizResultsViewModel(
                      title: "Этот раунд окончен!",
                      text: "Ваш результат: \(correctAnswers) из 10",
                      buttonText: "Сыграть ещё раз")
        show(quiz: viewModel )
      } else {
        currentQuestionIndex += 1
        show(quiz: convert(model: questions[currentQuestionIndex]))
      }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() { //Показал стартовый вопрос
        super.viewDidLoad()
show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        QuizQuestion(image: "The Dark Knight",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        QuizQuestion(image: "Kill Bill",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        QuizQuestion(image: "The Avengers",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        QuizQuestion(image: "Deadpool",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        QuizQuestion(image: "The Green Knight",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: true),
        QuizQuestion(image: "Old",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: false),
        QuizQuestion(image: "Vivarium",text: "Рейтинг этого фильма больше чем 6?",correctAnswer: false)
        ]
}

