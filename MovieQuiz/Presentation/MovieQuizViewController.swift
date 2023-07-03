import UIKit

struct QuizStepViewModel {
    let filmPosterImage: UIImage
    let question: String
    let questionCounterStr: String
    
    init(_ filmPosterImage: UIImage, _ question: String, _ questionCounterStr: String) {
        self.filmPosterImage = filmPosterImage
        self.question = question
        self.questionCounterStr = questionCounterStr
    }
}

struct QuizQuestion {
    private static let questionDefault: String = "Is this film rating greater than 6?"
    
    let filmPosterName: String
    let question: String
    let correctAnswer: Bool
    
    init(_ filmPosterName: String, _  correctAnswer: Bool, _ question: String = "") {
        self.filmPosterName = filmPosterName
        self.question = question.isEmpty ? QuizQuestion.questionDefault : question
        self.correctAnswer = correctAnswer
    }
}

struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
    
    init(_ title: String, _ text: String, _ buttonText: String) {
        self.title = title
        self.text = text
        self.buttonText = buttonText
    }
}

final class MovieQuizViewController: UIViewController {
    private let questions: [QuizQuestion] = [
            QuizQuestion("The Godfather", true),
            QuizQuestion("The Dark Knight", true),
            QuizQuestion("Kill Bill", true),
            QuizQuestion("The Avengers", true),
            QuizQuestion("Deadpool", true),
            QuizQuestion("The Green Knight", true),
            QuizQuestion("Old", false),
            QuizQuestion("The Ice Age Adventures of Buck Wild", false),
            QuizQuestion("Tesla", false),
            QuizQuestion("Vivarium", false)
        ]
    
    private var currentQuestionIdx: Int = 0
    private var correctAnswersCount: Int = 0
    
    @IBOutlet private weak var filmPosterImage: UIImageView!
    @IBOutlet private weak var questionCounterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmPosterImage.layer.masksToBounds = true
        filmPosterImage.layer.cornerRadius = 20
        
        showQuizStep(getQuizStep(currentQuestionIdx))
    }
    
    private func getCounterPostfix() -> String {
        return "/\(questions.count)"
    }
    
    private func getQuizStep(_ questionIdx: Int) -> QuizStepViewModel {
        return convertToQuizStep(questions[questionIdx])
    }
    
    private func convertToQuizStep(_ from: QuizQuestion) -> QuizStepViewModel {
        let retVal = QuizStepViewModel(
            UIImage(named: from.filmPosterName) ?? UIImage(), from.question,
            "\(currentQuestionIdx + 1)\(getCounterPostfix())")
        
        return retVal
    }
    
    private func showQuizStep(_ quizStep: QuizStepViewModel) {
        filmPosterImage.image = quizStep.filmPosterImage
        questionCounterLabel.text = quizStep.questionCounterStr
        questionLabel.text = quizStep.question
        
        filmPosterImage.layer.borderWidth = 0
    }
    
    private func showQuizResultAlert(_ result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIdx = 0
            self.correctAnswersCount = 0
            
            self.showQuizStep(self.getQuizStep(self.currentQuestionIdx))
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResult() {
        if currentQuestionIdx == questions.count - 1 {
            let resultText = "Your result: \(correctAnswersCount)\(getCounterPostfix())"
            let result = QuizResultsViewModel("This round is over!", resultText, "Play again")
            showQuizResultAlert(result)
        } else {
            currentQuestionIdx += 1
            showQuizStep(getQuizStep(currentQuestionIdx))
        }
    }
    
    private func showAnswerResultAndNextStep(isCorrect: Bool) {
        if isCorrect {
            correctAnswersCount += 1
        }
        
        filmPosterImage.layer.borderWidth = 8
        filmPosterImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: showNextQuestionOrResult)
    }
    
    @IBAction private func noButtonTap(_ sender: UIButton) {
        let correctAnswer = questions[currentQuestionIdx].correctAnswer
        showAnswerResultAndNextStep(isCorrect : !correctAnswer)
    }
    
    @IBAction private func yesButtonTap(_ sender: UIButton) {
        let correctAnswer = questions[currentQuestionIdx].correctAnswer
        showAnswerResultAndNextStep(isCorrect : correctAnswer)
    }
}
