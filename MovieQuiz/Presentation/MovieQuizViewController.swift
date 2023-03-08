import UIKit

final class MovieQuizViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - IBAOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // вопрос задан:
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // результат квиза:
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // результат ответа:
    private struct QuizAnswerResultViewModel {
        var result: Bool
    }
    
    // MARK: - private vars
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    static private let description = "Рейтинг этого фильма больше чем 6?"
    
    // MARK: - mocks
    // моки:
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: description,
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: description,
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: description,
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: description,
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: description,
            correctAnswer: false)
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        show(quiz: QuizStepViewModel(image: UIImage(), question: String(), questionNumber: String()))
    }
    
    // MARK: - IBActions
    @IBAction private func noButtonClick(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        freezeButton()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        freezeButton()
    }
    
    // MARK: - func freezeButton
    // функция заморозки кнопок (added)
    private func freezeButton(){
        if yesButton.isEnabled == true && noButton.isEnabled == true {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        } else
        if yesButton.isEnabled == false && noButton.isEnabled == false {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    // MARK: - funcs show
    // функции показа View-модели на экране:
   private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
       let currentQuestion = questions[currentQuestionIndex]
        imageView.image = convert(model: currentQuestion).image
        textLabel.text = convert(model: currentQuestion).question
        counterLabel.text = convert(model: currentQuestion).questionNumber
    }
   
    private func show( quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController (
            title: result.title, // заголовок всплывающего окна
            message: result.text, // текст во всплыв окне
            preferredStyle: .alert) // preferredStyle может быть .alert или  .actionSheet
        // создаем для него кнопки с действиями
        let action = UIAlertAction (title: result.buttonText,
                                    style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0 // скидываем счётчик правильных ответов
            
            //заново показываем 1 вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action) // доабвляем в алерт кнопки
        self.present(alert, animated: true, completion: nil)  // показываем всплывающее окно
    }
    
    // MARK: - convert
    // функция конвертации параметра image из String в UIImage
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), //распаковка картинки
            question: model.text , // текст вопроса
            questionNumber: "\(currentQuestionIndex + 1) /\(questions.count)") // счет номера вопроса
    }
    
    // MARK: - funcs showAnswer & DispatchQueue
    // функция ответа на вопрос
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // код, который вы хотите вызвать через 1 секунду:
            self.showNextQuestionOrResults()
            self.imageView.layer.borderColor = UIColor.ypBlack.cgColor
            self.imageView.layer.borderWidth = 0
            self.freezeButton()
                       
        }
    }
    
    // MARK: - funcs nexQuestion
    // фунцкия показа след шага-вопроса
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 { // -1 потому что индекс начинается с 0, а длина массива - с 1
            // показать результат квиза
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: text,
                buttonText: "Сыграть ещё раз")
            
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего вопроса на 1, так мы получим след вопрос
            // показать следующий вопрос
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
}
   
    
    /*
     Mock-данные
          
     Картинка: The Godfather
     Настоящий рейтинг: 9,2
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     Картинка: The Dark Knight
     Настоящий рейтинг: 9
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     Картинка: Kill Bill
     Настоящий рейтинг: 8,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: The Avengers
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: Deadpool
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: The Green Knight
     Настоящий рейтинг: 6,6
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА
     
     
     Картинка: Old
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: The Ice Age Adventures of Buck Wild
     Настоящий рейтинг: 4,3
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: Tesla
     Настоящий рейтинг: 5,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     
     
     Картинка: Vivarium
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     */
