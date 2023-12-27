import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var isTransitioning = false
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            text: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    private struct QuizQuestion {
        let image : String
        let text: String
        let correctQuestion: Bool
    }
    
    private struct QuizStepViewModel {
        let image : UIImage
        let text: String
        let questionNumber: String
    }
    
    private let questions : [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctQuestion: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 5?", correctQuestion: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 4?", correctQuestion: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctQuestion: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 5?", correctQuestion: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 3?", correctQuestion: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctQuestion: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 5?", correctQuestion: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 7?", correctQuestion: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 7?", correctQuestion: false)
    ]
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        if !isTransitioning {
            isTransitioning = true
            showAnswerResult(isCorrect: questions[currentQuestionIndex].correctQuestion == false)
        }
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        if !isTransitioning {
            isTransitioning = true
            showAnswerResult(isCorrect: questions[currentQuestionIndex].correctQuestion == true)
        }
        
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.text
        counterLabel.text = step.questionNumber
    }
    
    private func createTheImageBorder(){
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 6
    }
    
    private func cleanImageBorder(){
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 0
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        createTheImageBorder()
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.isTransitioning = false
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let alert = QuizResultsViewModel(title: "Этот раунд окончен", text: "Ваш результат: \(correctAnswers)/10", buttonText: "Сыграть еще раз")
            show(quiz: alert)
        } else {
            currentQuestionIndex += 1
            cleanImageBorder()
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
        
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            let nextQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: nextQuestion)
            self.show(quiz: viewModel)
            self.cleanImageBorder()
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
