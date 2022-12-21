import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol? = nil
    private var statisticService: StatisticService?
    
    // Показ первого вопроса
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        showLoadingIndicator()
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
       
}
        
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
          activityIndicator.isHidden = true
      }
    
    private func showNetworkError (message:String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз") {[weak self]_ in
            guard self != nil else {return}
            self?.questionFactory?.loadData()
            self?.showLoadingIndicator()
        }
        alertPresenter?.show(results: model)
    }
    
    // Заполнение картинки и текста данными
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // Отоброжение результата прохождения квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText){[weak self]_ in
            guard self != nil else {return}
        }
        self.alertPresenter?.show(results: alertModel)
        self.counterLabel.text = "1/10"
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
        
    }
    
    // Конвертация
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")  // высчитываем номер вопроса
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {correctAnswers += 1
        }
        if currentQuestionIndex == questionsAmount - 1  {
            showNextQuestionOrResults()
            return
        }
        // Создание рамки с цветом, который соответствует ответу
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderWidth = 8
        self.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor: UIColor.ypRed.cgColor
        self.currentQuestionIndex += 1
       
        // Показ следующего вопроса с задержкой в 1 секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.questionFactory?.requestNextQuestion()
            self.counterLabel.text = "\(self.currentQuestionIndex + 1)/10"
            self.imageView.layer.borderWidth = 0
            
        }
    }
    
    func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService?.store(correct: correctAnswers, total: questionsAmount)

            guard let bestGame = statisticService?.bestGame,
                    let gamesCount = statisticService?.gamesCount,
                    let totalAccuracy = statisticService?.totalAccuracy
            else {
                return
            }
        let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)\n Количество сыграных квизов: \(gamesCount) \n Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString)) \n Средняя точность: \(String(format:"%.2f", totalAccuracy))%",
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}


