import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var currentQuestionIndex = 0
    
    private var questionsAmount: Int = 10
    private var questionFactory: QuestionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    private var countCorrectAnswer = 0
    
    @IBOutlet private weak var imageView: UIImageView!
    
    
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet weak var buttonYes: UIButton!
    
    @IBOutlet weak var buttonNo: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        disableMyButtons()
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        disableMyButtons()
    }
    // MARK: - Lifecycle
    
    private func disableMyButtons() {
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.buttonNo.isEnabled = true
            self.buttonYes.isEnabled = true
        }
        
            
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
            return QuizStepViewModel (image: UIImage(named: model.image) ?? UIImage(),
                                      question: model.text,
                                      questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
                
            }

    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        if isCorrect{
            countCorrectAnswer += 1
        }
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
                self.imageView.layer.borderWidth = 0
                
            
            }
        }

    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questionsAmount - 1 {
            let textResult = countCorrectAnswer == questionsAmount ?
                    "Поздравляем, Вы ответили на 10 из 10!" :
                    "Вы ответили на \(countCorrectAnswer) из 10, попробуйте ещё раз!"
            
            let viewResult = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: textResult,
                        buttonText: "Сыграть ещё раз")
                    show(quiz: viewResult)
        } else {
            currentQuestionIndex += 1
            if let nextQuestion = questionFactory.requestNextQuestion() {
                currentQuestion = nextQuestion
                let viewModel = convert(model: nextQuestion)
                
                show(quiz: viewModel)
            } 
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        imageView.layer.cornerRadius = 20
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.countCorrectAnswer = 0
            
            if let firstQuestion = self.questionFactory.requestNextQuestion() {
                self.currentQuestion = firstQuestion
                let viewModel = self.convert(model: firstQuestion)
                
                self.show(quiz: viewModel)
            }
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstQuestion = questionFactory.requestNextQuestion() {
            currentQuestion = firstQuestion
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
        }
    }
}





struct Result {
    let answer: Bool
}



