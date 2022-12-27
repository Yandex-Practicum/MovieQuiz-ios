import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {

    // MARK: - Lifecycle
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!

    private var questionFactory: QuestionFactoryProtocol?
   // private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var correctAnswers = 0
    private let presenter = MovieQuizPresenter()
    private var statisticService: StatisticService = StaticticServiceImplementation()
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        showLoadingIndicator()
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self

    }
   
    // MARK: - QuestionFactoryDelegate
    func didRecieveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegate
    func didPresentAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        DispatchQueue.main.async {[weak self] in
        self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func show(quiz quizStepViewModel: QuizStepViewModel) {

        imageView.image = quizStepViewModel.image
        imageView.layer.cornerRadius = 20
        textLabel.text = quizStepViewModel.question
        counterLabel.text = quizStepViewModel.questionNumber
        
    }
    
    func showAnswerResult(isCorrect: Bool){
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else{
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            
        }
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            guard let self = self else {
                return
            }

            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
            self.imageView.layer.borderWidth = 0
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.statisticService = self.statisticService
            self.presenter.alertPresenter = self.alertPresenter
            self.presenter.showNextQuestionOrResults()
            
        })

    }
    
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModelResult = AlertModel(title: "Ошибка",
                                          message: message,
                                          buttonText: "Попробовать еще раз",
                                          completion: { [weak self] _ in
                                                        guard let self = self else {
                                                            return
                                                        }
                                                        self.correctAnswers = 0
                                                        self.presenter.resetQuestionIndex()
                                                        self.questionFactory?.requestNextQuestion()
                                        })
        alertPresenter?.showResult(alertModel: alertModelResult)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
