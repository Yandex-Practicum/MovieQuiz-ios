import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
        
    }
        
        // MARK: - QuestionFactoryDelegate
        
        func didRecieveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
        }
    
        
        // MARK: - Private Functions
        
        private func show(quiz step: QuizStepViewModel) { // Наполнение данными странички
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
        }
        
        private func show(quiz result: QuizResultsViewModel) { // Результат квиза
            let action = {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        
            let alert: AlertPresenter = AlertPresenter(title: result.title,
                                                       message: result.text,
                                                       buttonText: result.buttonText,
                                                       completion: action)
    
            alert.show(viewController: self)
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
        
        private func showNextQuestionOrResults() {
            if currentQuestionIndex == questionsAmount - 1 {
                let text = "Ваш результат: \(correctAnswers) из 10"
                let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                     text: text,
                                                     buttonText: "Сыграть еще раз")
                show(quiz: viewModel)
            } else {
                currentQuestionIndex += 1
                self.questionFactory?.requestNextQuestion()
            }
        }
        
        // MARK: - Actions
        
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
    }
