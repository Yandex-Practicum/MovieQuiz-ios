import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory()

    private var currentQuestion: QuizQuestion?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory?.delegate = self
        
        questionFactory?.requestNextQuestion()
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
    }
    
    // MARK: - QuestionFactoryDelegate

    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
                    return
        }
        currentQuestion = question
        showQuestion(question: question)
    }
   
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true, button: sender)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false, button: sender)
    }
    
    private func showQuestion(question: QuizQuestion) {
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = viewModel.image
            self?.textLabel.text = viewModel.question
            self?.counterLabel.text = viewModel.questionNumber
        }
    }
    
    private func showResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        })

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
       return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showAnswerResult(isCorrect: Bool, button actionButton: UIButton) {
        actionButton.isEnabled = false
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            actionButton.isEnabled = true
            
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.imageView.layer.borderColor = nil
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showResult(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результата: \(correctAnswers) из \(questionsAmount)",
                buttonText: "Сыграть еще раз"
            ))
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
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
