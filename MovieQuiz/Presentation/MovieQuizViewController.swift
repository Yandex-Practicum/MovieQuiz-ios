

import UIKit


final class MovieQuizViewController: UIViewController {
    
    //MARK: - IBOutlet

    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    
    // MARK: - Private Properties
    
    private let questions = QuizQuestion.questions
    private var currentQuestionsIndex = 0
    private var score = 0
    private var convertStepViewModel: QuizStepViewModel {
        convertToQuizStepViewModel(model: questions[currentQuestionsIndex])
    }
    
    // MARK: - Lifecyclequestions
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convertStepViewModel)
    }
    
    // MARK: - IBAction
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let answer = false
        let currentQuestion = questions[currentQuestionsIndex]
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let answer = true
        let currentQuestion = questions[currentQuestionsIndex]
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
}

// MARK: - Logic MovieQuizViewController
extension MovieQuizViewController {
    
    // MARK: - Private Methods
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.image = step.image
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: "\(Constatns.AlertLable.message) \(result.text)/ \(questions.count)",
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionsIndex = 0
            self.score = 0
            self.show(quiz: self.convertStepViewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convertToQuizStepViewModel(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: ("\(currentQuestionsIndex + 1) / \(questions.count)"))
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderColor = UIColor.YPGreen?.cgColor
            score += 1
        } else {
            imageView.layer.borderColor = UIColor.YPRed?.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionsIndex == questions.count - 1 {
            let addResultQuestion = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "\(score)",
                buttonText: "Сыграть еще раз")
            show(quiz: addResultQuestion)
        } else {
            currentQuestionsIndex += 1
            show(quiz: convertStepViewModel)
        }
    }
}
