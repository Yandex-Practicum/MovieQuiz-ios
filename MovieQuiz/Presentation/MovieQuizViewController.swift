import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    private var statisticService: StatisticService?
    private var alertPresenter: AlertPresenter?
    private let presenter = MovieQuizPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
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
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        
        let alertPresenter = AlertPresenter()
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] _ in
                guard let self = self else { return }
                
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        
        alertPresenter.showAlert(with: alertModel, in: self)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
    }
    
    
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion()  {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            guard (statisticService?.gamesCount) != nil else { return }
            guard (statisticService?.totalAccuracy) != nil else { return }
            guard (statisticService?.bestGame) != nil else { return }
            
            let text = "Ваш результат: \(correctAnswers)\\\(presenter.questionsAmount)"
            
            let alertPresenter = AlertPresenter()
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз") { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.presenter.resetQuestionIndex()
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                }
            
            alertPresenter.showAlert(with: alertModel, in: self)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
}
