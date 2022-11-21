import UIKit

extension UIColor{
    static var ypGreen: UIColor {UIColor (named: "YP Green")!}
    static var ypRed: UIColor {UIColor (named: "YP Red")!}
    
    
}

final class MovieQuizViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
         //   show(quiz: ) Наверное можно было сделать более красиво...
         //   буду рад услышать как! )
        let firstLoad = questions[currentQuestionIndex]
        let firstModel = convert(model: firstLoad)
        show(quiz: firstModel)
                
      //  imageView.image = UIImage(named: "The Godfather") ?? UIImage()
      //  textLabel.text = "Рейтинг этого фильма больше чем 6?"
      //  counterLabel.text = "1/10"
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
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
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
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var YesButton: UIButton!
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            // заметил баг, что если быстро кликать на кнопки - пока выводится это сообщение успевает проскочить на вопрос да в фоне. Это видимо изза нашей задержки в ShowResult? Как победить?
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        let currentQuestion = questions[currentQuestionIndex]
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text=step.question
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    private func showAnswerResult(isCorrect: Bool) {
    
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 1 // толщина рамки
        imageView.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
       // imageView.layer.borderColor = isCorrect ?? UIColor.yp Green.cgColor : UIColor.yp Red.cgColor Почемуто не видет мой цвет
        
        
     //  почему то не поулчается обратиться к подгруженным цветам....
        if isCorrect == true
        {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers = correctAnswers + 1
        }
        else
            {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
            self.YesButton.isEnabled = false
            self.noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.YesButton.isEnabled = true
            self.noButton.isEnabled = true
            self.imageView.layer.borderWidth = 0 // нужно же убрать рамку!
            self.showNextQuestionOrResults()
        }
    }
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default)
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

