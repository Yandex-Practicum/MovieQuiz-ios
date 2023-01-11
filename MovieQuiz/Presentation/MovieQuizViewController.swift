import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - private Outlet Variables
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var yesButtonOutlet: UIButton!
    @IBOutlet private weak var noButtonOutlet: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - private Variables
    private let presenter = MovieQuizPresenter()
    //иньектируем фабрику через свойство
    private var questionFactory: QuestionFactoryProtocol?
    private var correctAnswers: Int = 0 // правильные ответы
    var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius  = 20
        imageView.layer.masksToBounds = true
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        questionFactory?.loadData()
        showLoadingIndicator()
        presenter.viewController = self
    }
    
    @IBAction private func noButtonAction(_ sender: Any) {
        presenter.noButtonAction()
    }
    @IBAction private func yesButtonAction(_ sender: Any) {
        presenter.yesButtonAction()
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        yesButtonOutlet.isUserInteractionEnabled = false
        noButtonOutlet.isUserInteractionEnabled = false
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
           correctAnswers += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.imageView.layer.borderWidth = 0
            self.presenter.alertPresenter = self.alertPresenter
            self.presenter.statisticService = self.statisticService
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
            self.yesButtonOutlet.isUserInteractionEnabled = true
            self.noButtonOutlet.isUserInteractionEnabled = true
        }
    }
    
    func show(quiz step: QuizStepViewModel) { //метод показа вопроса
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber// здесь мы заполняем нашу картинку, текст и счётчик данными
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
             hideLoadingIndicator()

             let alertModel = AlertModel(title: "Ошибка",
                                         message: message,
                                         buttonText: "Попробовать ещё раз") {
                        [weak self] in
                        guard let self = self else {return}
                        self.questionFactory?.loadData()
                        self.showLoadingIndicator()
             }
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0
         alertPresenter?.show(results: alertModel)
         }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator() // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    
}
