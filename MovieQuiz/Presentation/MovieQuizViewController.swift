import UIKit

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizRezultViewModel {
    let title: String
    let text: String
    let buttonText: String
}

struct QuizeQuestion {
    let image: String
    let textQuestion: String
    let correctAnswer: Bool
    let rating: Double
}



final class MovieQuizViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    
    
    private var questions: [QuizeQuestion]!
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = getMockData()
        showNextQuestion()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction private func noButtonClicked() {
        let isCorrect = questions[currentQuestionIndex].correctAnswer == false
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func yesButtonClicked() {
        let isCorrect = questions[currentQuestionIndex].correctAnswer == true
        showAnswerResult(isCorrect: isCorrect)
    }
    
}


extension MovieQuizViewController {
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    private func show(quiz result: QuizRezultViewModel) {
        let alertController = UIAlertController(title: result.title,
                                                message: result.text,
                                                preferredStyle: .alert)
        
        let actionButton = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.showNextQuestion()
        }
        
        alertController.addAction(actionButton)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showNextQuestion() {
        self.imageView.layer.borderWidth = 0
        
        let currentQuestion = questions[currentQuestionIndex]
        let quizeStep = convert(model: currentQuestion)
        show(quiz: quizeStep)
    }
    
    
    private func convert(model: QuizeQuestion) -> QuizStepViewModel {
            return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                     question: model.textQuestion,
                                     questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            imageView.layer.borderColor = UIColor(named: "YP Green")?.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        }
        
        switchEnableForButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResult()
            self.switchEnableForButtons()
        }
    }
    
    private func switchEnableForButtons() {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
            let resultModel = QuizRezultViewModel(title: "Раунд окончен!",
                                                  text: "Ваш результат: \(correctAnswers)/\(questions.count)",
                                                  buttonText: "Сыграть еще раз")
            show(quiz: resultModel)
        } else {
            currentQuestionIndex += 1
            showNextQuestion()
        }
    }

    
    private func getMockData() -> [QuizeQuestion] {
        var quizeQuestions = [QuizeQuestion]()
        
        quizeQuestions.append(QuizeQuestion(image: "The Godfather",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: true,
                                            rating: 9.2))
        quizeQuestions.append(QuizeQuestion(image: "The Dark Knight",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: true,
                                            rating: 9))
        quizeQuestions.append(QuizeQuestion(image: "Kill Bill",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: true,
                                            rating: 8.1))
        quizeQuestions.append(QuizeQuestion(image: "The Avengers",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: true,
                                            rating: 8))
        quizeQuestions.append(QuizeQuestion(image: "Deadpool",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: true,
                                            rating: 8))
        quizeQuestions.append(QuizeQuestion(image: "The Green Knight",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: true,
                                            rating: 6.6))
        quizeQuestions.append(QuizeQuestion(image: "Old",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: false,
                                            rating: 5.8))
        quizeQuestions.append(QuizeQuestion(image: "The Ice Age Adventures of Buck Wild",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: false,
                                            rating: 4.3))
        quizeQuestions.append(QuizeQuestion(image: "Tesla",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: false,
                                            rating: 5.1))
        quizeQuestions.append(QuizeQuestion(image: "Vivarium",
                                            textQuestion: "Рейтинг этого фильма больше чем 6?",
                                            correctAnswer: false,
                                            rating: 5.8))
        
        return quizeQuestions
    }
}

