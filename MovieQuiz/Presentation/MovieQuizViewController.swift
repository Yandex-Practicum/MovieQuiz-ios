import UIKit

struct QuizQuestion {
    //строка с названием фильма
    //свпадает с названием картинки афиши фильма в Assets
    var image: String
    
    //строка с названием вопроса о фильме
    var text: String
    
    //будевое значение (true, false), дающее правильный ответ на вопрос
    var correctAnswer: Bool
}

struct QuizStepViewModel {
    
    var image: UIImage
    var question: String
    var questionNumber: String
    
}

var theGodfather: QuizQuestion = QuizQuestion(image: "The Godfather", text: "Рейтин этого фильма больше чем 6?", correctAnswer: true)

var theDarkKnight: QuizQuestion = QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var killBill = QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var theAvengers = QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var deadpool = QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var theGreenKnight = QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true)

var old = QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)

var theIceAgeAdvanturesOfBuckWild = QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

var tesla = QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

var vivarium = QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    
    @IBOutlet private weak var imageView: UIImageView!
    
    
    @IBOutlet private weak var textLabel: UILabel!
    
    private let questions: [QuizQuestion] = [theGodfather, theDarkKnight, killBill, theAvengers, deadpool, theGreenKnight, old, theIceAgeAdvanturesOfBuckWild, tesla, vivarium]
    
    // Переменная со счетчиком текущих вопросов
    private var currentQuestionIndex = 0
    
    // Счетчик правильных вариантов ответа
    private var correctAnswers = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        var currentQuestion = questions[currentQuestionIndex]
        var currentView = convert(model: currentQuestion)
        show(quiz: currentView)
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        var image = UIImage(named: model.image) ?? UIImage()
        var questionText: String = model.text
        var questionNumber: String = "\(currentQuestionIndex + 1)/\(questions.count)"
        
        return QuizStepViewModel(image: image, question: questionText, questionNumber: questionNumber)
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
     private func showAndwerResult(isCorrect: Bool) {

        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypgreen.cgColor : UIColor.ypred.cgColor

         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             self.showNextQuestionOrResult()
         }
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        var givenAnswer = true
        showAndwerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == givenAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        var givenAnswer = false
        showAndwerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == givenAnswer)
        }
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
