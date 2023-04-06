import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let nextQuestion = question else { return }
        currentQuestion = nextQuestion
        swapButtonsRandomly()
        
        let viewModel = convert(model: nextQuestion)
        show(quiz: viewModel)
        yesButton.isEnabled = true
        noButton.isEnabled = true
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func didLoadDataFromServer() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let errorMessage = (error as NSError).domain
        showNetworkError(message: errorMessage)
    }
    
    //MARK: - Properties
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol!
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService!
    private var alertPresenter: AlertPresenter!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        questionFactory.loadData()
        
        noButton.titleLabel?.font =  UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font =  UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        statisticService = StatisticServiceImplementation()
        alertPresenter = AlertPresenter(viewController: self)
    }
    
    //MARK: - Private functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let text = "Ваш результат: \(correctAnswers) из 10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            
        } else {
            
            currentQuestionIndex += 1
            
            yesButton.isEnabled = false
            noButton.isEnabled = false
            
            questionFactory.requestNextQuestion()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let accuracy = String(format: "%.2f", statisticService.totalAccuracy * 100)
        let gamesCount = statisticService.gamesCount
        let message = """
        Ваш результат: \(correctAnswers) из 10
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(statisticService.bestGame.correct) из 10 (\(statisticService.bestGame.date.dateTimeString))
        Средняя точность: \(accuracy)%
        """
        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText) { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                _ = currentQuestion
                questionFactory.requestNextQuestion()
            }
        alertPresenter.showAlert(alertModel: alertModel)
    }
    
    func swapButtonsRandomly() {
        let shouldSwap = Bool.random()
        if shouldSwap {
            let tempTitle = yesButton.title(for: .normal)
            yesButton.setTitle(noButton.title(for: .normal), for: .normal)
            noButton.setTitle(tempTitle, for: .normal)
            
            let tempAction = yesButton.actions(forTarget: self, forControlEvent: .touchUpInside)?.first
            yesButton.removeTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
            noButton.removeTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
            
            if tempAction == "yesButtonTapped" {
                yesButton.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
                noButton.addTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
            } else {
                yesButton.addTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
                noButton.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
            }
        }
    }
    
    private func showNetworkError(message: String) {
        self.activityIndicator.stopAnimating()
        self.UIStackView.isHidden = true
        let alertModel = AlertModel(title: "Ошибка :(", message: "Извините, произошла ошибка загрузки данных.", buttonText: "Попробовать еще раз!") {
            self.questionFactory.loadData()
            self.UIStackView.isHidden = false
        }
        alertPresenter.showAlert(alertModel: alertModel)
    }
    
    //MARK: - Outlets & Action
    
    @IBOutlet private var questionTitleLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet weak var UIStackView: UIStackView!
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer: Bool
        if noButton.title(for: .normal) == "Нет" {
            givenAnswer = false
        } else {
            givenAnswer = true
        }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer: Bool
        if yesButton.title(for: .normal) == "Да" {
            givenAnswer = true
        } else {
            givenAnswer = false
        }
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
}
