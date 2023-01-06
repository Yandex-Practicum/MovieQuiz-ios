import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
   
    // MARK: - Actions
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        let answer = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        let answer = true
        guard let currentQuestion = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Outlets
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textlabel: UILabel!
    @IBOutlet private var noButtonOutlet: UIButton!
    @IBOutlet private var yesButtonOutlet: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory(moviesLoader: MoviesLoader())
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private let moviesLoader = MoviesLoader()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textlabel.textAlignment = .center
        let noTitle = NSAttributedString(
            string: "Нет",
            attributes: [.font: UIFont(name: "YSDisplay-Medium", size: 20)!]
        )
        noButtonOutlet.setAttributedTitle(noTitle, for: .normal)
        let yesTitle = NSAttributedString(
            string: "Да",
            attributes: [.font: UIFont(name: "YSDisplay-Medium", size: 20)!]
        )
        yesButtonOutlet.setAttributedTitle(yesTitle, for: .normal)
        textlabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
    
        let gameCount: GameCount = GameCount(countOfGames: statisticService.gamesCount.countOfGames + 1)
        statisticService.gamesCount = gameCount
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        showLoadingIndicator()
        questionFactory?.delegate = self
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
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
        showNetworkError(error: error)
    }
    
    // MARK: - Private functions
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(error: Error) {
        hideLoadingIndicator()
        
        let alertModel: AlertModel = AlertModel(title: "Ошибка!", message: "Картинка не загружена. \(error.localizedDescription)", buttonText: "Попробовать ещё раз", completion: { [weak self] in
            guard let self = self else {return}
            self.questionFactory?.loadData()
        })
        alertPresenter.present(alert: alertModel, presentingViewController: self)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
   private func convert(model: MostPopularMovie) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(), // UIImage(named: model.imageURL) ?? UIImage(),
            question: model.title,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        let attributedText = NSAttributedString(
            string: step.question,
            attributes: [
                .font: UIFont(name: "YSDisplay-Medium", size: 24)!,
                .foregroundColor: UIColor.ypWhite
            ]
        )
        textlabel.attributedText = attributedText
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect == true {
            correctAnswers += 1
        }
        noButtonOutlet.isEnabled = false
        yesButtonOutlet.isEnabled = false
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResults()
            self.noButtonOutlet.isEnabled = true
            self.yesButtonOutlet.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        guard currentQuestionIndex == questionsAmount - 1 else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            imageView.layer.borderWidth = 0
            return
        }
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let bestRecord = statisticService.bestGame
        let totalCount = statisticService.gamesCount.countOfGames
        let totalAccuracy = statisticService.totalAccuracy?.totalAccuracyOfGame
        let totalAccuracyString: String
        if let totalAccuracy = totalAccuracy {
            totalAccuracyString = "Средняя точность: \(Int(totalAccuracy * 100))%"
        } else {
            totalAccuracyString = "Нет статистики"
        }
        
        let text = """
Ваш результат: \(correctAnswers)/\(questionsAmount)\n
Количесчтво сыгранных квизов: \(totalCount)\n
Рекорд: \(bestRecord.correct)/\(bestRecord.total) \(bestRecord.date.dateTimeString)\n
\(totalAccuracyString)
"""
        imageView.layer.borderWidth = 0
        let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть ещё раз", completion: { [weak self] in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter.present(alert: alertModel, presentingViewController: self)
    }
}

