import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let currentQuestions = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestions)
        show(quiz: viewModel)
        
    }
    
    
    
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
    
    struct quizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            
            // скидываем счётчик правильных ответов
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        _ = questions[currentQuestionIndex]
    }
    
    private var currentQuestionIndex: Int = 0
        
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
    
    
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    
    private var correctAnswers: Int = 0
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
        
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image : "The Godfather",
            //     Настоящий рейтинг: 9,2
            text: "Рейтинг этого фильма больше чем 6?" ,
            correctAnswer : true),
        
        QuizQuestion(
            image : "The Dark Knight",
            //     Настоящий рейтинг: 9
            text: "Рейтинг этого фильма больше чем 6?" ,
            correctAnswer : true),
        
        QuizQuestion(
            image : "Kill Bill",
            //     Настоящий рейтинг: 8,1
            text: "Рейтинг этого фильма больше чем 6?" ,
            correctAnswer : true),
        
        QuizQuestion(
            image : "The Avengers",
            //     Настоящий рейтинг: 8
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer : true),
        
        QuizQuestion(
            image : "Deadpool",
            //     Настоящий рейтинг: 8
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer : true),
        
        QuizQuestion(
            image : "The Green Knight",
            //     Настоящий рейтинг: 6,6
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer : true),
        
        QuizQuestion(
            image : "Old",
            //     Настоящий рейтинг: 5,8
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer : false),
        
        QuizQuestion(
            image : "The Ice Age Adventures of Buck Wild",
            //     Настоящий рейтинг: 4,3
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer : false),
        
        QuizQuestion(
            image : "Tesla",
            //     Настоящий рейтинг: 5,1
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer : false),
        
        QuizQuestion(
            image : "Vivarium",
            //     Настоящий рейтинг: 5,8
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer : false),
    ]
    
                    }

