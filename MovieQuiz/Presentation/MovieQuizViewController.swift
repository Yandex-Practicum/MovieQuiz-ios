import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var numberOfGame = 0
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
//        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(delegate: self)
        
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
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
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        // здесь мы заполняем нашу картинку, текст и счётчик данными
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, text: result.text, buttonText: result.buttonText, completion: { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            // скидываем счётчик правильных ответов
            self.correctAnswers = 0
            // заново показываем первый вопрос
            self.questionFactory?.requestNextQuestion()
            self.setEnabledButtons(isEnabled: true)
            
        })
        self.alertPresenter?.showAlert(model: alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        setEnabledButtons(isEnabled: false)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderColor = UIColor.ypBlack.cgColor
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let bestGameRes = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"
            let text = """
            Ваш результат: \(correctAnswers) из \(questionsAmount)
            Количество сыгранных квизов:\(statisticService.gamesCount)
            Рекорд: \(bestGameRes) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy) + "%")
            """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            setEnabledButtons(isEnabled: true)
        }
    }
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    private func setEnabledButtons(isEnabled: Bool)  {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               text: message,
                               buttonText: "Попробовать еще раз",
                               completion:{ [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.loadData()
            self.questionFactory?.requestNextQuestion()
        })
        
        self.alertPresenter?.showAlert(model: model)
    }
}
