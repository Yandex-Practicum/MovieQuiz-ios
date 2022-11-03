import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterProtocol {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var presenter = MovieQuizPresenter()
    private var currentGame = GameRecord(correct: 0, total: 10, date: Date())
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private var totalCorrect: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
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
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: Any) {
        answerIs(answer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        answerIs(answer: true)
    }
    
    // MARK: - Private functions
    private func answerIs(answer: Bool) {
        showAnswerResult(isCorrect: answer == currentQuestion?.correctAnswer)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadindIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadindIndicator() // скрываем индикатор загрузки
        
        let errorModel = UIAlertController(title: "Что-то пошло не так(", message: message, preferredStyle: .alert)
        errorModel.addAction(UIAlertAction(title: "Попробуйте еще раз", style: .default) { action in
            self.questionFactory?.loadData()
            self.questionFactory?.requestNextQuestion()
            self.showLoadingIndicator()
        })
        self.present(errorModel, animated: true, completion: nil)
        
    }
    
    private func showNextQuestionOrResults() {
        if self.presenter.isLastQuestion() { 
            statisticService.store(correct: currentGame.correct, total: currentGame.total) // сравниваем рекорд с текущей игрой
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                            text: "Ваш результат: \(currentGame.correct) из \(currentGame.total)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date.dateTimeString)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%",
                                            buttonText: "Сыграть еще раз"))
            questionFactory?.resetIndex()
        } else {
            self.presenter.switchToNextQuestion() // увеличиваем индекс текущего вопроса на 1; таким образом мы сможем получить следующий вопрос
            // показать следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // делаем рамку цветной
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
            self?.imageView.layer.borderColor = UIColor.clear.cgColor
            self?.yesButton.isEnabled = true
            self?.noButton.isEnabled = true
        }
        if isCorrect { currentGame.correct += 1 }
        
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
        imageView.image = step.image
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.currentGame.correct = 0
            self.presenter.resetQuestionIndex()
            guard let currentQuestion = self.currentQuestion else {
                return
            }
            self.show(quiz: self.presenter.convert(model: currentQuestion))
            self.questionFactory?.requestNextQuestion()
        }
        
        showAlert(alertModel: alertModel)
        
    }
    
}
