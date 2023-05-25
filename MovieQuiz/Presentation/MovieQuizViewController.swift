import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    private let presenter = MovieQuizPresenter()
    
    private var questionFactory: QuestionFactory?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenterImpl(viewContoller: self)
        
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactoryImpl(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImpl()
        presenter.viewController = self
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if let superview = imageView.superview {
            imageView.frame.size = superview.frame.size
        }
        
        showLoadingIndicator()
        
        questionFactory?.loadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - Actions
    
    @IBAction private func YesButton(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
                presenter.yesButtonClicked()
    }
    
    @IBAction private func NoButton(_ sender: UIButton) {
        presenter.currentQuestion = currentQuestion
               presenter.noButtonClicked()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
                    self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(alertModel: model)
    }
    
    func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func toggleButtonsInteraction(_ enabled: Bool) {
        yesButton.isUserInteractionEnabled = enabled
        noButton.isUserInteractionEnabled = enabled
    }
    
    
    
    private func show(quiz viewModel: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
    }
    
     func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        toggleButtonsInteraction(false)
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
        }
    }
    private func showNextQuestionOrResults () {
        toggleButtonsInteraction(true)
        if presenter.isLastQuestion() {
            showFinalResults()
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    
    private func showFinalResults() {
        let statisticService = StatisticServiceImpl()
        statisticService.store(correct: correctAnswers, total: presenter.questionsCount)
        
        let alertModel = AlertModel(
            title: "Игра окончена",
            message: makeResultMessage(),
            buttonText: "ОК",
            buttonAction: { [weak self] in
                self?.handleFinalResults()
            }
        )
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self] _ in
            self?.handleFinalResults()
        }
        
        let alertController = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    private func handleFinalResults() {
        correctAnswers = 0
        presenter.resetQuestionIndex()
        questionFactory?.requestNextQuestion()
    }

    
    private func makeResultMessage() -> String {
        guard let statisticService = statisticService, let bestGame = statisticService.bestGame else {
            assertionFailure("error messege")
            return ""
        }
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy)
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(presenter.questionsCount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + " (\(bestGame.date.dateTimeString))"
        
        let averageAccuracyLine = "Средняя точность: \(accuracy)%"
        
        let components: [String] = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ]
        let resultMessage = components.joined(separator: "\n")
        
        return resultMessage
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveQuestion(_ question: QuizQuestion) {
        self.currentQuestion = question
        let viewModel = presenter.convert(model: question)
        self.show(quiz: viewModel)
    }
}
