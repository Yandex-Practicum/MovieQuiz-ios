import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) { // Наполнение данными странички
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func show(quiz result: QuizResultsViewModel) { // Результат квиза
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            if let firstQuestion = self.questionFactory.requestNextQuestion() {
                self.currentQuestion = firstQuestion
                let viewModel = self.convert(model: firstQuestion)
                
                self.show(quiz: viewModel)
            }
        }

        
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
        
    private func showAnswerResult(isCorrect: Bool) {
            
        imageView.layer.masksToBounds = true // разрешение на рамку
        imageView.layer.borderWidth = 8 // толщина
        imageView.layer.cornerRadius = 20 // радиус скругления углов
        imageView.layer.borderColor = UIColor.white.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
            
        if isCorrect == true {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor // верно - зеленая рамка
            } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor // неверно - красная рамка
            }
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
                
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
                
            }
    }
        
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let userAnswer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
            
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
        
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let userAnswer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
            
        showAnswerResult(isCorrect: userAnswer == currentQuestion.correctAnswer)
    }
        
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
        let text = "Ваш результат: \(correctAnswers) из 10"
        let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                             text: text,
                                             buttonText: "Сыграть еще раз")
        show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            if let nextQuestion = questionFactory.requestNextQuestion() {
                let viewModel = convert(model: nextQuestion)
                
                show(quiz: viewModel)
            }
        }
    }
}
