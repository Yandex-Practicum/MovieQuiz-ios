import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    
    
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counetLabel: UILabel!

    @IBOutlet private var textLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions [currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        
    }
    
    
    private var correctAnswers: Int = 0  // счетчик правильных ответов
    private  var currentQuestionIndex : Int = 0 // индекс текущего вопроса
    
    
    struct QuizStepViewModel {     //  view модель для состояния "Вопрос задан"
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    
    struct QuizResultsViewModel {   // view модель для состояния "Результат квиза"
        let title: String
        let text: String
        let buttonText: String
        
    }
    
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
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
    
    
    
    private func convert(model : QuizQuestion) -> QuizStepViewModel {// конвертация из мок данных в модель которую надо //показать на экране
        
       
        
        return QuizStepViewModel (
            image: UIImage(named: model.image) ?? UIImage(), // Распаковка картинки
            question: model.text, // берем текст вопроса
            questionNumber: "\(currentQuestionIndex + 1) / \(questions.count)"  // высчитываем номер вопроса
        )
        
    }
    
    private func show(quiz step: QuizStepViewModel) {  // здесь мы заполняем нашу картинку, текст и счётчик данными
        
        imageView.image = step.image
        textLabel.text = step.question
        counetLabel.text = "\(step.questionNumber)"
       
    }
    
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { // счетчик правильных ответов
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { //задержка 1 сек перед показом след вопроса
            self.imageView.layer.borderColor =  UIColor.ypWhite.cgColor
            self.showNextQuestionOrResults()
        }
        
    }
    
    
    private func show(quiz result: QuizResultsViewModel ) {
        let alert = UIAlertController (
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title : result.buttonText, style: .default) {_ in
            self.currentQuestionIndex = 0
            
            self.correctAnswers = 0 //Обнуляем счетчик правильных ответов
            
            let firstQuestion = self.questions[self.currentQuestionIndex]  //заново показываем первый вопрос
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex == questions.count-1 {
            let text = "Ваш результат : \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel (
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            
            show(quiz: viewModel)
            
        } else{
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
        
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        let firstQuestion = self.questions[self.currentQuestionIndex]  //заново показываем первый вопрос
        let viewModel = self.convert(model: firstQuestion)
        self.show(quiz: viewModel)
        
    }
}
