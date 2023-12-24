import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegatePrototocol {

    // MARK: - Lifecycle
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var correctAnswers = 0
    
    private lazy var questionFactory = QuestionFactory(movieLoader: MovieLoader())
    
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter = AlertPresenter()
    
    private var presenter = MovieQuizPresenter()
    
    private var statisticImplementation: StatisticServiceProtocol = StatisticServiceImplementation()
    
    //Определяем внешний вид статус бара в приложении
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //инъекция зависимости для определения делегата
        questionFactory.delegate = self
        presenter.viewController = self
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        showLoadingIndictor()
        questionFactory.loadData()
        
        //Загружаем необходимый вид статус бара
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK: - Описание метдов Делегата
    
    func didFinishReceiveQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    //MARK: - Работа с индикатором состояни загрузки
    
    private func showLoadingIndictor(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError (message: String){
        hideLoadingIndicator()
        
        let networkConnectionAlert = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз"){ [weak self] in
            guard let selfAction = self else {return}
            
            selfAction.correctAnswers = 0
            selfAction.presenter.resetQuestionIndex()
            selfAction.questionFactory.loadData()
            
        }
        alertPresenter.showAlert(quiz: networkConnectionAlert, controller: self)
    }
    
 
    //MARK: - Основные методы приложения
    
    private func isButtonsBlocked(state: Bool) {
        if state {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        } else {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    func show(quiz step: QuizStepViewModel) {
        
        UIView.transition(with: imageView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            self.imageView.image = step.image
            self.imageView.layer.borderWidth = 0
        },
                          completion: { _ in
            self.textLabel.text = step.question
            self.counterLabel.text = step.questionNumber
            self.isButtonsBlocked(state: false)
        })
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
        isButtonsBlocked(state: true)
        imageView.layer.borderWidth = 8
        
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypgreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypred.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            guard let dispatch = self else { return }
            dispatch.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult() {
        if presenter.isLastQuestion() {
            
            statisticImplementation.store(correct: correctAnswers, total: presenter.questionAmount)
            
            //Определяем формат даты в виде 03.06.22 03:22
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YY HH:mm"
            let formattedDate = dateFormatter.string(from: statisticImplementation.bestGame.date)
            
            //Данные для модели Алерта
            let alerTitle = "Этот раунд окончен!"
            let alertMessage = """
            Ваш результат: \(correctAnswers)/\(presenter.questionAmount)
            Количество сыгранных квизов: \(statisticImplementation.gamesCount)
            Рекорд: \(statisticImplementation.bestGame.correct)/\(statisticImplementation.bestGame.total) (\(formattedDate))
            Средняя точность: \(String(format: "%.2f", statisticImplementation.totalAccurancy * 100))%
            """
            let alertButtonText = "Сыграть ещё раз"
            
            let alertModel = AlertModel(title: alerTitle, message: alertMessage, buttonText: alertButtonText) { [ weak self ] in
                
                if let selfAction = self {
  
                    selfAction.correctAnswers = 0
                    selfAction.presenter.resetQuestionIndex()
                    selfAction.questionFactory.requestNextQuestion()
                }
            }
            
            alertPresenter.showAlert(quiz: alertModel, controller: self)
            
        } else {
            presenter.switchQuestionIndex()
            questionFactory.requestNextQuestion()
        }
    }
    
    // MARK: - ActionButtons
    
    //Определяем действие кнопки "Да"
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    //Определяем действие кнопки "Нет"
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
}
