import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory()
        questionFactory?.delegate = self
        
        
        //выводим первый вопрос на экран
        //получаем первый элемент из мок данных
        //let currentQuestion = questions[currentQuestionIndex]
        //конвертируем модель вопроса вл вью модель
        //let firstView = convert(model: currentQuestion)
        //показываем вопрос на экране
        //show(quiz: firstView)
        
        //if let firstQuestion = questionFactory.requestNextQuestion() {
        //    currentQuestion = firstQuestion
        //    let viewModel = convert(model: firstQuestion)
        //    show(quiz: viewModel)
        //}
        questionFactory?.requestNextQuestion()
    }
    //MARK: -QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    //MARK: - properties
    
    //если нажал кнопку нет
    @IBAction private func noButtonClicked(_ sender: UIButton)  {
        //let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    //если нажал кнопку да
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        //let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    // переменная с индексом текущего вопроса
    private var currentQuestionIndex = 0
    //переменная со счетчиком правильных ответов
    private var correctAnswers = 0
    //количество вопросов квиза
    private let questionsAmount: Int = 10
    //обьявляем фабрику вопросов
    private var questionFactory: QuestionFactoryProtocol?
    //текущий вопрос который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    
    //MARK: - private functions
    //приватный метод вывода на экран вопроса который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    //приватный метод который меняет цвет рамки
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        //метод красит рамку
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        //запускаем следующую задачу через 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            //убираем границу рамки
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        
    }
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // идём в состояние "Результат квиза"
            let text = correctAnswers == questionsAmount ? "Поздравляем, Вы ответили на 10 из 10!" : "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз!"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            
            show(quiz: viewModel)
            
        } else {
            currentQuestionIndex += 1
            
            
            //let nextQuestion = questions[currentQuestionIndex]
            //let viewModel = convert(model: nextQuestion)
            //show(quiz: viewModel)
            ///if let nextQuestion = self.questionFactory.requestNextQuestion() {
              ///  self.currentQuestion = nextQuestion
              ///  let viewModel = self.convert(model: nextQuestion)
                
             ///   self.show(quiz: viewModel)
            ///}
            
            self.questionFactory?.requestNextQuestion()
        
        }
    }
    // константа с кнопкой для системного алерта
    
    private let alert = UIAlertController(
        title: "Этот раунд окончен!",
        message: "Ваш результат ???",
        preferredStyle: .alert)
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            // сбрасываем переменную с количеством правильных ответов
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            //let firstQuestion = self.questions[self.currentQuestionIndex]
            //let viewModel = self.convert(model: firstQuestion)
            //self.show(quiz: viewModel)
            
            ///if let firstQuestion = self.questionFactory.requestNextQuestion() {
                ///self.currentQuestion = firstQuestion
                ///let viewModel = self.convert(model: firstQuestion)
                
                ///self.show(quiz: viewModel)
            
            ///}
            
            self.questionFactory?.requestNextQuestion()
            
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
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
