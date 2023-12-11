import UIKit

final class MovieQuizViewController: UIViewController {
    
    private var currentQuestionIndex = 0
    private var correctAnswer = 0
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionTextView: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let curretnQuestion = question[currentQuestionIndex]
        let resaltOfConvert = convert(model: curretnQuestion)
        show(quiz: resaltOfConvert)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        answerGived(answer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        answerGived(answer: false)
    }
    
    private func answerGived(answer: Bool) {
        showAnswerResult(isCorrect: question[currentQuestionIndex].correntAnswer == answer)
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
            
            let firstQuestion = question[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
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
            questionNumber: "\(currentQuestionIndex + 1)/\(question.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionTextView.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == question.count - 1 {
            let text = "Ваш результат: \(correctAnswer)/10"
            let viewModel = QuizResultViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
            
            showResult(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = question[currentQuestionIndex]
            let goToConvert = convert(model: nextQuestion)
            
            show(quiz: goToConvert)
        }
    }
    
    private func enableButtons(isEnable: Bool) {
        yesButton.isEnabled = isEnable
        noButton.isEnabled = isEnable
    }
}

struct QuizQuestion {
    let image : String
    let text : String
    let correntAnswer : Bool
}

struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

struct QuizResultViewModel {
    let title : String
    let text: String
    let buttonText : String
}

private let question : [QuizQuestion] = [
    QuizQuestion(
        image: "The Godfather",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: true),
    QuizQuestion(
        image: "The Dark Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: true),
    QuizQuestion(
        image: "Kill Bill",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: true),
    QuizQuestion(
        image: "The Avengers",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: true),
    QuizQuestion(
        image: "Deadpool",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: true),
    QuizQuestion(
        image: "The Green Knight",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: true),
    QuizQuestion(
        image: "Old",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: false),
    QuizQuestion(
        image: "The Ice Age Adventures of Buck Wild",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: false),
    QuizQuestion(
        image: "Tesla",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: false),
    QuizQuestion(
        image: "Vivarium",
        text: "Рейтинг этого фильма больше чем 6?",
        correntAnswer: false)
]
