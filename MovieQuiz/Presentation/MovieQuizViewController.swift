import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var textView: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var indexView: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let questionAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol? = AlertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()
    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter?.delegate = self
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let firstQuestion = question else { return }
            currentQuestion = firstQuestion
            let viewModel = convert(model: firstQuestion)
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
    }
    
    func showResults() {
        statisticService.store(correct: correctAnswers, total: questionAmount)
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: """
            Ваш результат: \(correctAnswers)/\(questionAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """,
            buttonText: "Ок",
            buttonAction: { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.yesButton.isEnabled = true
                self?.noButton.isEnabled = true
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.showAlert(with: alertModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        posterImageView.image = step.image
        textView.text = step.question
        indexView.text = step.questionNumber
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                                   message: message,
                                   buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
            
        alertPresenter?.showAlert(with : model)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect { correctAnswers += 1 }
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.borderWidth = 8
        posterImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.posterImageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
        }
        
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionAmount - 1{
            showResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion() 
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    @IBAction private func noButton(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            print("No signal")
            return
        }
        showAnswerResult(isCorrect: currentQuestion.answer == false)
    }
    
    @IBAction private func yesButton(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            print("No signal")
            return
        }
        showAnswerResult(isCorrect: currentQuestion.answer == true)
    }
}


