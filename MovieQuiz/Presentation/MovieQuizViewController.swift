import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
     var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        alertPresenter = AlertPresenter()
        alertPresenter?.controller = self
        
        questionFactory = QuestionFactory()
        questionFactory?.delegate = self
        
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
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
            let givenAnswer = false
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
        
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
            let givenAnswer = true
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
   
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")// высчитываем номер вопроса// берём текст вопроса
    }
    
    private func convert(model: QuizResultsViewModel, action: @escaping (UIAlertAction) -> Void) -> AlertModel {
        return AlertModel(title: model.title, message: model.text, buttonText: model.buttonText, action: action)
        }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // показать результат квиза
            let text = "Ваш результат: \(correctAnswers) из \(questionsAmount)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            imageView.layer.borderWidth = 0
            
            let action: (UIAlertAction) -> Void = {
              _ in self.currentQuestionIndex = 0

              // скидываем счетчик правильных ответов
              self.correctAnswers = 0
            }
       
            
            alertPresenter?.show(alert: convert(model: viewModel, action: action))
            
        } else {
            imageView.layer.borderWidth = 0
            currentQuestionIndex += 1 // увеличиваем индекс текущего урока на 1, т.о. мы сможем получить следующий урок
            questionFactory?.requestNextQuestion()
            
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        // здесь мы показываем верно или нет ответил пользователь
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
        
    }
    
 
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
}

