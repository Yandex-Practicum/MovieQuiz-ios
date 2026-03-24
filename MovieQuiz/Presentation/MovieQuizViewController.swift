import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
        
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        checkAnswer(userAnswer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        checkAnswer(userAnswer: false)
    }
    

    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10 // общее количество вопросов квиза
    private var questionFactory: QuestionFactory? // фабрика вопросов, контроллер будет обращаться за вопросами к ней
    private var currentQuestion: QuizQuestion? // вопрос который видит пользователь
    
    private var alertPresenter = AlertPresenter()
    private var statisticService = StatisticService()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
       imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticService()

        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - Функция загрузки данных с сервера
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - Функция вылаи ошибки при загрузке
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмем в качестве сообщения описание ошибки
    }
    
    
    // MARK: - Функция индикатора загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // MARK: - Функция скрытия индикатора загрузки
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }
    
    // MARK: - QuestionFactoryDelegate (Делегат)
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            showError(message: "Не удалось загрузить вопрос")
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async{ [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // Функция ошибки сети
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка сети",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else {return}
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
        alertPresenter.show(in: self, model: model)
    }
    
    // вывод ошибки в виде алерта
    private func showError(message: String) {
        
//        было
//        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Принял", style: .default))
//        present(alert, animated: true)
        
        //стало
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Принял") { } // Пусто, если ничего делать не нужно
        
        alertPresenter.show(in: self, model: model)
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    } 
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    

    
    private func checkAnswer(userAnswer: Bool) {
        
        guard let current = currentQuestion else { return } // проверяем, что вопрос есть

        let isCorrect = current.correctAnswer == userAnswer
        
        if isCorrect == true {
            correctAnswers += 1
        }
            
        // красим рамку
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect
            ? UIColor(resource: .ypGreenIOS).cgColor
            : UIColor(resource: .ypRedIOS).cgColor
        
        //  задержка 3 секунды перед переходом к следующему вопросу
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.goToNextQuestion()
        }
    }
    
    // метод перехода к следующему вопросу
    private func goToNextQuestion() {
        imageView.layer.borderColor = UIColor(resource: .ypBlackIOS).cgColor
        
        //проверяем на окончание вопросов
        if currentQuestionIndex < (questionsAmount) - 1 {
            currentQuestionIndex += 1

            questionFactory?.requestNextQuestion() // запрашиваем следующий вопрос через фабрику
        } else {
            // это конец!
            showQuizFinished()
        }
    }
    
    
    private func showQuizFinished() {
        
        let message = "Ваш результат:  \(correctAnswers)/\(questionsAmount)\n" +
            "Количество сыграных квизов:\(statisticService.gamesCount)\n" +
        "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)\n" +
            "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        let model = AlertModel(
            title: "Раунд окончен",
            message: message,
            buttonText: "Сыграть еще раз"
        ) { [weak self] in
            guard let self = self else {return}
            self.restartQuiz()
        }
        alertPresenter.show(in: self, model: model)
        
        //сохраним результаты
        statisticService.store(correct: correctAnswers, total: questionsAmount)
    }
    
    private func restartQuiz() {
        // 1. Сброс счётчиков
        currentQuestionIndex = 0
        correctAnswers = 0
        
        // 2. Сброс визуальных эффектов
        imageView.layer.borderWidth = 0  // убрать рамку
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        
        // 3. Показать первый вопрос
        questionFactory?.requestNextQuestion()
        
    }
}




