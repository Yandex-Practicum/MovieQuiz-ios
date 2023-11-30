import UIKit

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}


struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: (String) -> String
    let buttonText: String
}

final class MovieQuizViewController: UIViewController {
    
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
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private var userAnswer = false
    private var currentQuizQuestion = QuizQuestion(image: "", text: "", correctAnswer: false)
    private let quizResultViewModel = QuizResultsViewModel(
        title: "Этот раунд окончен!",
        text: {
            (correctResults: String) -> String in
            "Ваш результат:\(correctResults)/10!"
        },
        buttonText: "Сыграть ещё раз")
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var previewImageView: UIImageView!
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuizQuestion = questions[currentQuestionIndex]
        let quizStepViewModel = convert(model: currentQuizQuestion)
        show(quizStepViewModel: quizStepViewModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/10")
    }
    
    private func show(quizStepViewModel: QuizStepViewModel) {
        previewImageView.image = quizStepViewModel.image
        questionLabel.text = quizStepViewModel.question
        counterLabel.text = quizStepViewModel.questionNumber
    }
    
    private func presentNextQuizStepQuestion(){
        UIView.animate(withDuration: 1.5){
            self.currentQuizQuestion = self.questions[self.currentQuestionIndex]
            let quizStepViewModel = self.convert(model: self.currentQuizQuestion)
            self.show(quizStepViewModel: quizStepViewModel)
        }
    }
    
    private func showQuizResults(){
        let alert = UIAlertController(
            title: quizResultViewModel.title,
            message: quizResultViewModel.text(correctAnswers.description),
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: quizResultViewModel.buttonText, style: .default) { _ in
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            self.presentNextQuizStepQuestion()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        var color = UIColor(resource: .ypRed).cgColor
        if isCorrect {
            correctAnswers += 1
            color = UIColor(resource: .ypGreen).cgColor
        }
       configureImageFrame(color: color)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.configureImageFrame(color: (UIColor(resource: .ypGray).withAlphaComponent(0)).cgColor)
            self.showNextQuestionOrResults()
        }
    }
    
    private func configureImageFrame(color: CGColor){
        UIView.animate(withDuration: 0.68) {
            self.previewImageView.layer.masksToBounds = true
            self.previewImageView.layer.borderWidth = 8
            self.previewImageView.layer.cornerRadius = 20
            self.previewImageView.layer.borderColor = color
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            presentNextQuizStepQuestion()
        }
    }
    
    @IBAction private func yesButtonTapped(_ sender: Any) {
        userAnswer = true
        showAnswerResult(isCorrect: userAnswer == currentQuizQuestion.correctAnswer)

    }
    
    @IBAction private func noButtonTapped(_ sender: Any) {
        userAnswer = false
        showAnswerResult(isCorrect: userAnswer == currentQuizQuestion.correctAnswer)
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
