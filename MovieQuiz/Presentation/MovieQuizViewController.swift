import UIKit

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

final class MovieQuizViewController: UIViewController {
    
    private struct Text {
        static let question: String = "Рейтинг этого фильма больше чем 6?"
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    private let questions: [QuizQuestion] = [
        .init(image: Assets.godfatherImageName, text: Text.question, correctAnswer: true),
        .init(image: Assets.darkKnightImageName, text: Text.question, correctAnswer: true),
        .init(image: Assets.killBillImageName, text: Text.question, correctAnswer: true),
        .init(image: Assets.avengersImageName, text: Text.question, correctAnswer: true),
        .init(image: Assets.deadpoolImageName, text: Text.question, correctAnswer: true),
        .init(image: Assets.greenKnightImageName, text: Text.question, correctAnswer: true),
        .init(image: Assets.oldImageName, text: Text.question, correctAnswer: false),
        .init(image: Assets.iceAgeAdventuresImageName, text: Text.question, correctAnswer: false),
        .init(image: Assets.teslaImageName, text: Text.question, correctAnswer: false),
        .init(image: Assets.vivariumImageName, text: Text.question, correctAnswer: false)
        
    ]
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var playedQuizes = 0
    private var bestScore: (score: Int, date: String) = (0, "")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = convert(model: questions[currentQuestionIndex])
        show(quiz: viewModel)
    }
    
    //MARK: - private methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        currentQuestionIndex += 1
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = Constants.borderWidth
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = Constants.cornerRadius
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [ weak self ] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func isAnswerCorrect(answer: Bool) {
        let currentQuestion = questions[currentQuestionIndex - 1]
        let isCorrect = currentQuestion.correctAnswer == answer
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func generateResultText() -> String {
        let averageAccuracy = Double(correctAnswers) / Double(questions.count) * 100.0
        let formattedAccuracy = formatAccuracy(averageAccuracy)
        
        let text = "Ваш результат: \(correctAnswers)/\(questions.count)  Количество сыгранных квизов: \(playedQuizes) Рекорд: \(bestScore.score)/\(questions.count) (\(bestScore.date) Средняя точность: \(formattedAccuracy)"
        
        return text
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count {
            self.playedQuizes += 1
            
            if correctAnswers > bestScore.score {
                bestScore.score = correctAnswers
                bestScore.date = formatCurrentDate()
            }
            
            let resultText = generateResultText()
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: resultText,
                buttonText: "Сыграть ещё раз")
            
            showAlert(quiz: viewModel)
        } else {
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        }
    }
    
    private func showAlert(quiz result: QuizResultsViewModel) {
        let alertController = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [ weak self ] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func formatCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    private func formatAccuracy(_ accuracy: Double) -> String {
        return String(format: "%.2f%%", accuracy)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        isAnswerCorrect(answer: true)
    }
    
    @IBAction func noButtonClicked(_ sender: Any) {
        isAnswerCorrect(answer: false)
    }
}

fileprivate struct Constants {
    static let cornerRadius: CGFloat = 20
    static let borderWidth: CGFloat = 8
}
