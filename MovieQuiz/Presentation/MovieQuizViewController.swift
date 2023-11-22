import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
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
    
    private var currentIndex: Int = 0 {
        didSet {
            if(currentIndex >= questions.count) {
                show(quiz: QuizResultsViewModel(
                    title: "Этот раунд закончен",
                    text: "Ваш результат: \(correctAnswers) из \(questions.count)",
                    buttonText: "Сыграть еще раз"));
            } else {
                show(quiz: convert(model: questions[currentIndex]))
            }
        }
    }
    private var correctAnswers: Int = 0;
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        show(quiz: convert(model: questions[currentIndex]))
    }
    
    // MARK: - Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image)!
        let question = model.text
        let questionNumber = "\(currentIndex+1)/\(questions.count)";
        
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
        imageView.layer.masksToBounds = true
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
        imageView.layer.masksToBounds = true
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            self.currentIndex = 0
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if(isCorrect) {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.currentIndex += 1
        }
    }
    
    
    
    // MARK: - Callbacks
    @IBAction private func yesBtnPressed(_ sender: Any) {
        let correctAnswer = questions[currentIndex].correctAnswer;
        showAnswerResult(isCorrect: correctAnswer);
        
    }
    
    @IBAction private func noBtnPressed(_ sender: Any) {
        let correctAnswer = questions[currentIndex].correctAnswer;
        showAnswerResult(isCorrect: !correctAnswer);
    }
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

// вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
  // строка с заголовком алерта
  let title: String
  // строка с текстом о количестве набранных очков
  let text: String
  // текст для кнопки алерта
  let buttonText: String
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
