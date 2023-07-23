import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //  MARK: - IB Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var questionTitleLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    
    //  MARK: - Private Properties
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let alertPresenter = AlertPresenter()
    private var statisticService: StatisticService?
    
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var correctAnswers = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setFonts()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.requestNextQuestion()
        alertPresenter.viewController = self
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    //  MARK: - UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //  MARK: - QuestionFactoryDelegate
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
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetWorkError(message: error.localizedDescription)
    }
    
    //  MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //  MARK: -  Private Methods
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetWorkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
        alertPresenter.showAlert(model: model)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }

            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let accurancyProcentage = "\(String(format: "%.2f", statisticService.totalAccuracy))%"
            let bestGameDate = statisticService.bestGame.date.dateTimeString
            let totalGamesCount = statisticService.gamesCount
            let currentCorrectRecord = statisticService.bestGame.correct
            let currentTotalRecord = statisticService.bestGame.total
            
            let text = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(totalGamesCount)
                Рекорд: \(currentCorrectRecord)/\(currentTotalRecord) (\(bestGameDate))
                Средняя точность: \(accurancyProcentage)
                """
            
            let viewModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть еще раз") { [weak self] in
                    self?.currentQuestionIndex = 0
                    self?.correctAnswers = 0
                    
                    self?.questionFactory?.requestNextQuestion()
                }
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func getStatistic(_ statistic: StatisticService) -> StatisticService {
        statistic
    }
             
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect
        ? UIColor.ypGreen.cgColor
        : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)  { [weak self ]  in 
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled.toggle()
            self.yesButton.isEnabled.toggle()
            self.imageView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/ \(questionsAmount)"
        )
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
        imageView.image = step.image
    }
    
    private func show(quiz model: AlertModel) {
        alertPresenter.showAlert(model: model)
    }
    
    private func setFonts() {
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
}

  // MARK: - AlertPresenterDelegate
extension MovieQuizViewController: AlertPresenterDelegate {
    func alertPresent(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}
