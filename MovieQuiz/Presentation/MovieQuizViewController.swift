import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswer = 0
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionTextView: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory()
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        answerGived(answer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        answerGived(answer: false)
    }
    
    private func answerGived(answer: Bool) {
        guard let correntAnswer = currentQuestion else {return}
        showAnswerResult(isCorrect: correntAnswer.currentAnswer == answer)
    }
    
    private func showResult(quiz resultViewModel: QuizResultViewModel) {
        let alert = UIAlertController(
            title: resultViewModel.title,
            message: resultViewModel.text,
            preferredStyle: .alert)

        let action = UIAlertAction(title: resultViewModel.buttonText, style: .default) { [weak self] _ in
            guard let self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswer = 0
            questionFactory?.requestNextQuestion()
        }

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswer += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        enableButtons(isEnable: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.enableButtons(isEnable: true)
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func convert(model : QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionTextView.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            let text = "Ваш результат: \(correctAnswer)/10"
            let viewModel = QuizResultViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
            
            showResult(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion().self
        }
    }
    
    private func enableButtons(isEnable: Bool) {
        yesButton.isEnabled = isEnable
        noButton.isEnabled = isEnable
    }
}
