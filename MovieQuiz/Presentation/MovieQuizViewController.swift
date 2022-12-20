import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        waitShowNextQuestion()
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        waitShowNextQuestion()
    }
    
    private var correctAnswers: Int = 0     //счетчик правильных ответов
    private var currentQuestionIndex = 0    //индекс текущего вопроса
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        show(quiz: convert(model: currentQuestion))
        
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
    
    //mock-данные описываются такой структурой
    struct QuizQuestion {
        let imageName: String
        let text: String
        let correctAnswer: Bool
        
    }
    
    //10 вопросов квиза представлены в виде массива
    private let questions: [QuizQuestion] = [
        QuizQuestion(imageName: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(imageName: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(imageName: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(imageName: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(imageName: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(imageName: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(imageName: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(imageName: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(imageName: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(imageName: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    //преобразуем данные, которые есть в модели вопроса в те данные,
    //которые необходимо показать
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.imageName) ?? UIImage()
        let questionNumber = "\(currentQuestionIndex + 1)/\(questions.count)"
        let question = model.text
        return QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
    }
    
    
    
    //Заполняем счетчик, картинку, текст вопроса данными. Рамку убираем
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
    }
    
    //Показываем результат прохождения квиза
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //функция показывающая правильный/неправильный результат
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.cornerRadius = 15
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
    }
    
    private func waitShowNextQuestion() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }

    }
    
    //функция показа следующего вопроса
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
    
    
}

