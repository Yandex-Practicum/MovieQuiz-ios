import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    
    private let questionsAmount: Int = 10
    private lazy var questionFactory: QuestionFactoryProtocol = {
        let factory = QuestionFactory()
        factory.delegate = self
        return factory
    }()
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    // MARK: - Private functions
    private func customizationUI(){
        view.backgroundColor = UIColor.ypBlack
        
        noButton.setTitle("Нет", for: .normal)
        noButton.setTitleColor(UIColor.ypBlack, for: .normal)
        noButton.backgroundColor = UIColor.ypWhite
        noButton.layer.cornerRadius = 15
        noButton.frame.size = CGSize(width: 157, height: 60)
        
        yesButton.setTitle("Да", for: .normal)
        yesButton.setTitleColor(UIColor.ypBlack, for: .normal)
        yesButton.backgroundColor = UIColor.ypWhite
        yesButton.layer.cornerRadius = 15
        yesButton.frame.size = CGSize(width: 157, height: 60)
        
        textLabel.text = "Вопрос:"
        textLabel.textColor = UIColor.ypWhite
        textLabel.frame.size = CGSize(width: 72, height: 24)
        
        
        counterLabel.textColor = UIColor.ypWhite
        counterLabel.frame.size = CGSize(width: 72, height: 24)
        questionLabel.textColor = UIColor.ypWhite
        questionLabel.frame.size = CGSize(width: 72, height: 24)
        
        imageView.layer.cornerRadius = 20
    }
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self]_ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            questionFactory.requestNextQuestion()
        }
        
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
                        question: model.text,
                        questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { // 1
            correctAnswers += 1 // 2
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
                    "Поздравляем, вы ответили на 10 из 10!" :
                    "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let viewModel = QuizResultsViewModel( // 2
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel) // 3
        } else {
            currentQuestionIndex += 1
            self.questionFactory.requestNextQuestion()
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
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
    // MARK: - Lifecycle
    override final func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
        customizationUI()
    }
    // MARK: - IBOutlet
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBAction private func yesButtonPressed(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
}

