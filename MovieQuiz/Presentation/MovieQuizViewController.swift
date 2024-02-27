import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions [currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult (isCorrect: givenAnswer == currentQuestion.correctAnswer )
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult (isCorrect: givenAnswer == currentQuestion.correctAnswer )
    }
    
    
    private let questions: [QuizQuestion] = [QuizQuestion (image: "The Godfather",
                                                           text: "Рейтинг этого фильма больше чем 6?",
                                                           correctAnswer: true),
                                             QuizQuestion(image: "The Dark Knight",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "Kill Bill",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "The Avengers",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "Deadpool",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "The Green Knight",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: true),
                                             QuizQuestion(image: "Old",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: false),
                                             QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: false),
                                             QuizQuestion(image: "Tesla",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: false),
                                             QuizQuestion(image: "Vivarium",
                                                          text: "Рейтинг этого фильма больше чем 6?",
                                                          correctAnswer: false),]
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        let currentQuestion = questions[currentQuestionIndex]
        
        show(quiz: convert(model: currentQuestion))
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel{
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect == true {
            correctAnswers += 1
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            
        } else {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResult()
        }
    }
    
    
    private func showNextQuestionOrResult () {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат:\(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            
            showQuizResult(quiz: viewModel)
            
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
        
        imageView.layer.borderWidth = 0
    }
    
    private func showQuizResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}


struct ViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

// Для состояния "Вопрос Показан"
struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

//Для состояния "Результат квиза "
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


