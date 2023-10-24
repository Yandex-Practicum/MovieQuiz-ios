import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet private weak var textView: UILabel!
    @IBOutlet private weak var indexView: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
    }
    
    @IBAction private func noButton(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            print("No signal")
            return
        }
        showAnswerResult(isCorrect: currentQuestion.answer == false)
    }
    
    @IBAction private func yesButton(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            print("No signal")
            return
        }
        showAnswerResult(isCorrect: currentQuestion.answer == true)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.filmName) ?? UIImage(), question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let firstQuestion = question else { return }
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        posterImageView.image = step.image
        textView.text = step.question
        indexView.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect { correctAnswers += 1 }
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.borderWidth = 8
        posterImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.posterImageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionAmount - 1{
            let alert = UIAlertController(
                title: "Этот раунд окончен!",
                message: "Ваш результат \(correctAnswers) из \(questionAmount)",
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
                self.questionFactory?.requestNextQuestion()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion() 
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
}


