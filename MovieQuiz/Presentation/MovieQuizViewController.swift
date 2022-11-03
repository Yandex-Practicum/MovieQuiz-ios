import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate/*, AlertPresenterDelegate*/ {
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
     var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
     let questionsAmount: Int = 10
    
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    
    private weak var alertPresenter: AlertPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    // MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            alertPresenter?.show()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
//    private func show(quiz result: QuizResultsViewModel) {
//
//        let allert = UIAlertController(
//            title: result.title,
//            message: result.text,
//            preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Replay", style: .default, handler: { [weak self] _ in
//            guard let self = self else { return }
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            self.imageView.layer.borderWidth = 0
//
//            self.questionFactory?.requestNextQuestion()
//        }
//        )
//        allert.addAction(action)
//        self.present(allert, animated: true)
//    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if !isCorrect {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
