import UIKit

final class MovieQuizViewController: UIViewController {
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    //структура для mock-данных
    struct QuizQuestion {
            let image: String
            let text: String
            let correctAnswer: Bool
        }
    //массив mock-данных
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
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)]
    
    //вью-модели для каждого из состояний:
    // для состояния "Вопрос задан"
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }
    // для состояния "Результат квиза"
    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    
    //функции, которые будут показывать View-модели на экране
    private func show(quiz step: QuizStepViewModel) {
      // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        mainQuestionLabel.text = step.question
        counterLabel.text = "\(currentQuestionIndex+1)/10"
    }
    //показываем окончательный результат
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            // скидываем счётчик правильных ответов
                self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //конвертация из QuizQuestion -> QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
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
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
                correctAnswers += 1
            }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    private func isAnswerCorrect(button: Bool) {
        if button {
            if questions[currentQuestionIndex].correctAnswer == true {
                showAnswerResult(isCorrect: true)
            } else {
                showAnswerResult(isCorrect: false)
            }
        } else {
            if questions[currentQuestionIndex].correctAnswer == true {
                showAnswerResult(isCorrect: false)
            } else {
                showAnswerResult(isCorrect: true)
            }
        }
    }
    
    //IB Action и Outlet (привязка к интерфейсу)
    @IBAction private func yesButtonPressed(_ sender: UIButton) {
        isAnswerCorrect(button: true)
    }
    
    @IBAction private func noButtonPressed(_ sender: UIButton) {
        isAnswerCorrect(button: false)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var mainQuestionLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        var firstQuestion = convert(model: questions[0])
        imageView.image = firstQuestion.image
        mainQuestionLabel.text = firstQuestion.question
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.white.cgColor
    }
}
