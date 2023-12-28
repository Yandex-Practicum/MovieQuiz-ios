import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let question = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return question
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        questionLabel.text = step.question
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        chooseIsEnableButtons(false)
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
        chooseIsEnableButtons(false)
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showAlert(quiz: QuizResultsViewModel(title: "Раунд окончен!", text: "Ваш результат: \(correctAnswers)/10", buttonText: "Сыграть еще раз"))
        } else {
            chooseIsEnableButtons(true)
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    private func showAlert(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {[weak self] _ in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
        
            questionFactory?.requestNextQuestion() 
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func settingUI() {
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        imageView.layer.cornerRadius = 20
        yesButton.layer.cornerRadius = 15
        noButton.layer.cornerRadius = 15
    }
    
    private func chooseIsEnableButtons(_ enabled: Bool){
        yesButton.isEnabled = enabled
        noButton.isEnabled = enabled
    }
    
}
