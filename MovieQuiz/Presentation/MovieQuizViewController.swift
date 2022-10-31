import UIKit

final class MovieQuizViewController: UIViewController {

    private var currentIndex = 0
    private var correctCount = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.layer.cornerRadius = 20
        show(quiz: convert(model: questions[currentIndex]))
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        if questions[currentIndex].correctAnswer {
            showAnswerResult(isCorrect: false)
        } else {
            showAnswerResult(isCorrect: true)
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        if questions[currentIndex].correctAnswer {
            showAnswerResult(isCorrect: true)
        } else {
            showAnswerResult(isCorrect: false)
        }
    }
    

    
    private func showNextQuestionOrResults() {
        if currentIndex == questions.count - 1 {
            let viewModel = QuizResultsViewModel(title: "Этот раунд закончен",
                                                 text: "Ваш результат \(correctCount) из 10",
                                                 buttonText: "Сыграть еще раз")
            
            show(quiz: viewModel)

        } else {
            currentIndex += 1
            let viewModel = convert(model: questions[currentIndex])
            self.imageView.layer.borderColor = nil
            self.show(quiz: viewModel)
            }
        }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        if isCorrect {
            correctCount += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){  self.showNextQuestionOrResults()
        }
    }
    
    
    struct QuizQuestion {
      let image: String
      let text: String
      let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }

    private let questions: [QuizQuestion] = [
                                     QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                     QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                     QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                     QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                     QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                     ]
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
      // Попробуйте написать код конвертации сами
        var num: String = ""
        
        for (i,j) in questions.enumerated(){
            if j.image == model.image {
                num = String(i + 1) + "/" + String(questions.count)
            }
        }
        
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: num)
        
      }
    
    
    private func show(quiz step: QuizStepViewModel) {
      // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image =  step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }

    private func show(quiz result: QuizResultsViewModel) {
      // здесь мы показываем результат прохождения квиза
        //и сбрасываем все до 0
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default, handler: { _ in
            self.currentIndex = 0
            self.correctCount = 0
            
            let viewModel = self.convert(model: self.questions[self.currentIndex])
            
            self.show(quiz: viewModel)
        })
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil )
        
    }
    
}

