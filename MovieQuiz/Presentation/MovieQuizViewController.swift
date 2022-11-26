import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
    }
    // MARK: - Structs
    
    // сам квиз
    struct QuizQuestion {
        let image: String
        let text:String
        let correctAnswer: Bool
    }
    //вопрос квиза
    struct QuizStepViewModel {
      let image: UIImage
      let question: String
      let questionNumber: String
    }
    //результат квиза
    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    // MARK: - Questions
    
  private  let questions:[QuizQuestion] = [QuizQuestion(image: "The Godfather", text:  "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                    QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                    QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                    QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                    QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                    QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                    QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                    QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                    QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                    QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
]
    

    // MARK: - IB
    @IBOutlet private var noButtonOutlet: UIButton!
    @IBOutlet private var yesButtonOutlet: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        noButtonOutlet.isEnabled = false
        showAnswerResult(isCorrect: false == questions[currentQuestionIndex].correctAnswer )
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        yesButtonOutlet.isEnabled = false
        showAnswerResult(isCorrect: true == questions[currentQuestionIndex].correctAnswer )
    }
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    //MARK: - vars
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var countOfSessions: Int = 0
    private var biggesNumberOfRightAnsers:Int = 0
    
    //MARK: - funcs
    private func showAnswerResult(isCorrect:Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            if self.imageView.layer.borderColor == UIColor.ypGreen.cgColor {
                self.correctAnswers += 1
            }
            self.showNextQuestionOrResults()
            self.noButtonOutlet.isEnabled = true
            self.yesButtonOutlet.isEnabled = true
        }
        
    }
    
    private  func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
    }
    
    private  func show(quiz rezult: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: rezult.title,
            message: rezult.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: rezult.buttonText,
                                   style: .default) { [self] _ in
            print("clicked")
            self.currentQuestionIndex = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            show(quiz: self.convert(model: firstQuestion))
        }
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questions.count - 1{
            countOfSessions += 1
            
            if correctAnswers > biggesNumberOfRightAnsers {
            biggesNumberOfRightAnsers = correctAnswers
            }
            let text = "Ваш результат: \(correctAnswers)/\(questions.count) \n Количество сыгранных квизов: \(countOfSessions) \n Рекорд: \(biggesNumberOfRightAnsers)/\(questions.count)"
            let newViewModel =  QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: newViewModel)
            correctAnswers = 0
            imageView.layer.borderWidth = 0
         
        } else {
            imageView.layer.borderWidth = 0
            currentQuestionIndex += 1
            show(quiz: self.convert(model: questions[currentQuestionIndex]))
                    }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1) / \(questions.count) "
        )
        
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
