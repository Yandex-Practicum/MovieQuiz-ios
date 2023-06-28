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
        
        let quizStep0 = convertToQuizStep(questions[currentQuestionIdx])
        //ShowQuizStep(quizStep0)
    }
    
    private func convertToQuizStep(_ from: QuizQuestion) -> QuizStepViewModel {
        let retVal = QuizStepViewModel(
            UIImage(named: from.filmPosterName) ?? UIImage(), from.question,
            "\(currentQuestionIdx + 1)/\(questions.count)")
        
        return retVal
    }
    
    private func ShowQuizStep(_ quizStep: QuizStepViewModel) {
        filmPosterImage.image = quizStep.filmPosterImage
        questionCounterLabel.text = quizStep.questionCounterStr
        questionLabel.text = quizStep.question
    }
    
    @IBAction private func noButtonTap(_ sender: Any) {
    }
    
    @IBAction private func yesButtonTap(_ sender: Any) {
    }
}
