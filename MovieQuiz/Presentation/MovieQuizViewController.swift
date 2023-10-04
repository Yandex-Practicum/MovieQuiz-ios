import UIKit

<<<<<<< HEAD
final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //выводим первый вопрос на экран
        //получаем первый элемент из мок данных
        let currentQuestion = questions[currentQuestionIndex]
        //конвертируем модель вопроса вл вью модель
        let firstView = convert(model: currentQuestion)
        //показываем вопрос на экране
        show(quiz: firstView)
    }
    //если нажал кнопку нет
    @IBAction private func noButtonClicked(_ sender: UIButton)  {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    //если нажал кнопку да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
=======
final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)
        
        alertPresenter = AlertPresenterImpl(viewController: self)

        showLoadingIndicator()
    }
    /*
    //MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    */
    //MARK: - actions
    //если нажал кнопку нет
    @IBAction private func noButtonClicked(_ sender: UIButton)  {
        presenter.noButtonClicked()
    }
    //если нажал кнопку да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
>>>>>>> sprint_5
    }
    
    // MARK: -Properties
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
<<<<<<< HEAD
    //для состояния вопрос показан
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // для состояния результат квиза
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    // переменная с индексом текущего вопроса
    private var currentQuestionIndex = 0
    
    //переменная со счетчиком правильных ответов
    private var correctAnswers = 0
=======
    //вызываем алерт презентер
    private var alertPresenter: AlertPresenter?
    //private var statisticService: StatisticService?
    //обьявляем презентер
    private var presenter: MovieQuizPresenter!
>>>>>>> sprint_5
    
    private struct QuizQestion {
        // строка с названием фильма
        //совпадает с названием афиши фильма в assets
        let image: String
        // строка с вопросом о рейтинге фильма
        let text: String
        // буллево значение правильный ответ на вопрос
        let correctAnswer: Bool
    }
    
    //приватный метод вывода на экран вопроса который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    //массив мок вопросов
    private let questions: [QuizQestion] = [
        QuizQestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
<<<<<<< HEAD
    private func convert(model: QuizQestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
=======
    //метод состояния индикатора загрузки
    func showLoadingIndicator() {
        //говорит что индикатор загрузки не скрыт
        activityIndicator.isHidden = false
        //включаем анимацию
        activityIndicator.startAnimating()
>>>>>>> sprint_5
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    //алерт показа ошибки загрузки
    func showNetworkError(message: String) {
        //cкрываем индикатор загрузки
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз",
                               buttonAction:  { [weak self] in
            self?.presenter.restartGame()
    }
        )
        alertPresenter?.show(alertModel: model)
         }
 
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
        //метод красит рамку
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
<<<<<<< HEAD
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        //запускаем следующую задачу через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //убираем границу рамки
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        
    }
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            // идём в состояние "Результат квиза"
            let text = "Ваш результат: \(correctAnswers)/10"
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
=======
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
>>>>>>> sprint_5
        }
    
    func noImageBorder() {
        //убираем границу рамки
        imageView.layer.borderWidth = 0
    }
    
    // константа с кнопкой для системного алерта
    
   // private let alert = UIAlertController(
   //     title: "Этот раунд окончен!",
   //     message: "Ваш результат ???",
   //     preferredStyle: .alert)
    
    func showFinalResults() {
     
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: presenter.makeResultMessage(),
            buttonText: "Сыграть еще раз!",
            buttonAction: { [weak self] in
                self?.presenter.restartGame()
            }
        )
        
        
<<<<<<< HEAD
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            // сбрасываем переменную с количеством правильных ответов
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
=======
        alertPresenter?.show(alertModel: alertModel)
>>>>>>> sprint_5
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
