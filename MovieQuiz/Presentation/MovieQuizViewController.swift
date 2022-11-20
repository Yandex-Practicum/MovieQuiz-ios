import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private var correctAnswers: Int = 0
    var currentQuestionIndex: Int = 0
    
    // Структура вопроса
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
    
    // массив вопросов+картинка+нужный ответ
    let questions: [QuizQuestion] = [
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
    
    // Капот до настроек
    override func viewDidLoad() {
        let imageName = questions[currentQuestionIndex].image
        let text = questions[currentQuestionIndex].text
        guard let image = UIImage(named: imageName) else { return }
        imageView.image = image
        textLabel.text = text
    }
    
    // Заполнение данных
    private func show(quiz step: QuizStepViewModel) {
        let imageName = questions[currentQuestionIndex].image
        let text = questions[currentQuestionIndex].text
        guard let image = UIImage(named: imageName) else { return }
        imageView.image = image
        textLabel.text = text
    }
    
    // Результат
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {_ in
            self.currentQuestionIndex = 0
            
            // скидываем счётчик правильных ответов
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
            self.counterLabel.text = "1/10"
            self.imageView.layer.masksToBounds = true
            self.imageView.layer.borderWidth = 8
            self.imageView.layer.borderColor = UIColor.black.cgColor
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Конверция
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let currentQuestion = questions[currentQuestionIndex]
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if currentQuestionIndex == questions.count - 1 {
            showNextQuestionOrResults()
            return
        }
        
        if isCorrect {
            correctAnswers += 1
        }
        // рамка с цветом в зависимости от ответа
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.green.cgColor: UIColor.red.cgColor
        currentQuestionIndex += 1
        
        // запуск кода через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let imageName = self.questions[self.currentQuestionIndex].image
            let text = self.questions[self.currentQuestionIndex].text
            guard let image = UIImage(named: imageName) else { return }
            self.imageView.image = image
            self.textLabel.text = text
            
            self.counterLabel.text = "\(self.currentQuestionIndex + 1)/10"
        }
    }
    // Действие после ответа на вопрос
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


