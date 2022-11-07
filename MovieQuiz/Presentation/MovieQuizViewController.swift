import UIKit

// Исходные данные

struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}


// для состояния "Вопрос задан"

struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

// для состояния "Результат квиза"

struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}


final class MovieQuizViewController: UIViewController {
    
    
    
    private var currentQuestionIndex: Int = 0
    
   
    
    private var correctanswerQuestion = 0
    
    
    private var currentQuestion: QuizQuestion { questions[currentQuestionIndex]
    }
    
       
    @IBOutlet var nobutton: UIButton!
    
   
    @IBOutlet var yesbutton: UIButton!
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenanswer = false
        showAnswerResult(isCorrect: givenanswer == currentQuestion.correctAnswer)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenanswer = true
        showAnswerResult(isCorrect: givenanswer == currentQuestion.correctAnswer)
    }
    
        
    
    // Картинка
    
    @IBOutlet private var imageView: UIImageView!
    
    // Текст вопрса
    
    @IBOutlet private var textLabel: UILabel!
    
    // Счетчик текущего вопроса
    
    @IBOutlet private var counterLabel: UILabel!
    
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
        
    
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctanswerQuestion+=1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        imageView.layer.cornerRadius = 20
        
      
        
        self.yesbutton.isEnabled = false
        
        self.nobutton.isEnabled = false
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
                     
            self.yesbutton.isEnabled = true
            
            self.nobutton.isEnabled = true
            
            self.imageView.layer.borderColor = UIColor.clear.cgColor
            
            self.showNextQuestionOrResults()
            
               
            
            }

    }
    
    

    
    private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            counterLabel.text = step.questionNumber
            textLabel.text = step.question
        }
    

    
   
    private func showNextQuestionOrResults(){
           if currentQuestionIndex == questions.count - 1{
               let text = "Ваш результат: \(correctanswerQuestion) из 10"
               let viewModel = QuizResultsViewModel(title: "Этот раунд окончен",
                                                    text: text,
                                                    buttonText: "Сыграть еще раз")
             
                           
               show(quiz: viewModel)
               
           }
        
        
        else {
               currentQuestionIndex += 1
               let nextQuestion = questions[currentQuestionIndex]
               let viewModel = convert(model: nextQuestion)
               
               show(quiz: viewModel)
           }
       }
        
    
    
    private func show(quiz result: QuizResultsViewModel) {
               let alert = UIAlertController(title: result.title,
                                         message: result.text,
                                         preferredStyle: .alert)
           let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
               
               self.currentQuestionIndex = 0
               
               self.correctanswerQuestion = 0
               
               
               
               let firstQuestion = self.questions[self.currentQuestionIndex]
               let viewModel = self.convert(model: firstQuestion)
               self.show(quiz: viewModel)
           }
           alert.addAction(action)
           self.present(alert, animated: true, completion: nil)
   }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        
        let viemodel = convert(model: questions[currentQuestionIndex])
        
        show(quiz: viemodel)
    }
    
    
    
    
    
    private let questions: [QuizQuestion] = [
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
}


