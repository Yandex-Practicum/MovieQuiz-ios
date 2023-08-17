import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {
    
    // MARK: - Lifecycle
    
    //Типы на экране
    struct ViewModel {
        let image: UIImage
        let questions: String
        let questionNumber: String
    }
    
    var alertPresenter: AlertPresenterProtocol?
    
    var statisticService: StatisticService?
    
    var currentQuestion: QuizQuestion?
    
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        presenter.viewController = self

        alertPresenter = AlertPresenter(delegate: self)
        
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        
        screenSettings()
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        //setUnavailableButtons()
    }
    @IBAction func yesButtonClicked(_ sender: UIButton) {
        //setUnavailableButtons()
        presenter.yesButtonClicked()
        
    }
    
    @IBOutlet private weak var imageViev: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //не скрыт
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    //скрыт
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Попробовать еще раз", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter.restartGame()
        }
        alert.addAction(action)
    }
    
    func showResult() {
        //statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
        statisticService?.updateGameStatisticService(correct: presenter.correctAnswers, amount: presenter.questionsAmount)
        let gameRecord = GameRecord(correct: presenter.correctAnswers, total: presenter.questionsAmount, date: Date())
        
        if let bestGame = statisticService?.bestGame,
            gameRecord > bestGame {
            statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        }
        
        let alertModel = AlertModel(
            text: "Этот раунд окончен",
            message: makeMessage(),
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                guard let self = self else { return }
                
                self.presenter.resetQuestionIndex()
                self.presenter.correctAnswers = 0
                ///1111/self.questionFactory?.requestNextQuestion()
                self.presenter.restartGame()
            })
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func makeMessage() -> String { //MARK:
        guard let gamesCount = statisticService?.gamesCount,
              let recordCount = statisticService?.bestGame.correct,
              let recordTotal = statisticService?.bestGame.total,
              let recordTime = statisticService?.bestGame.date.dateTimeString,
              let average = statisticService?.totalAccuracy else {
            return "Ошибка при формировании сообщения"
        }
        
        let message = "Ваш результат: \(presenter.correctAnswers)\\\(presenter.questionsAmount)\n"
            .appending("Количество сыгранных квизов: \(gamesCount)\n")
            .appending("Рекорд: \(recordCount)/\(recordTotal) (\(recordTime))\n")
            .appending("Средняя точность \(String(format: "%.2f", average))%")
        return message
    }
    
    private func buttonsIsDisabled(){
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func buttonsIsEnabled(){
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
        
    //Приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default){ [weak self] _ in
                guard let self = self else { return }
                self.presenter.restartGame()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    func show(quiz step: QuizStepViewModel) {
        imageViev.layer.borderColor = UIColor.clear.cgColor
        imageViev.image = step.image
        textLabel.text = step.question
        indexLabel.text = step.questionNumber
        screenSettings()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageViev.layer.masksToBounds = true
        imageViev.layer.borderWidth = 8
        imageViev.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    private func setUnavailableButtons() {
        noButton.isUserInteractionEnabled = false
        yesButton.isUserInteractionEnabled = false
    }
    
    private func setAvailableButtons() {
        noButton.isUserInteractionEnabled = true
        yesButton.isUserInteractionEnabled = true
    }
    
    private func screenSettings() {
        questionTitleLabelStyle()
        counterLabelStyle()
        imageViewStyle()
        imageViewBorderStyle()
        textLabelStyle()
        yesButtonStyle()
        noButtonStyle()
    }
    
    private func questionTitleLabelStyle() {
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.textColor = .ypWhite
    }
    
    private func counterLabelStyle() {
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        indexLabel.textColor = .ypWhite
    }
    
    private func imageViewStyle() {
        imageViev.layer.cornerRadius = 20
        imageViev.contentMode = .scaleAspectFill
        imageViev.backgroundColor = .ypWhite
    }
    
    private func textLabelStyle() {
        textLabel.textColor = .ypWhite
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
    }
    
    private func yesButtonStyle() {
        yesButton.setTitle("Да", for: .normal)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.setTitleColor(.ypBlack, for: .normal)
        yesButton.layer.cornerRadius = 15
        yesButton.backgroundColor = .ypWhite
    }
    
    private func noButtonStyle() {
        noButton.setTitle("Нет", for: .normal)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.setTitleColor(.ypBlack, for: .normal)
        noButton.layer.cornerRadius = 15
        noButton.backgroundColor = .ypWhite
    }
    
    private func imageViewBorderStyle() {
        imageViev.layer.masksToBounds = true
        imageViev.layer.borderWidth = 8
        imageViev.layer.borderColor = UIColor.clear.cgColor
        imageViev.layer.cornerRadius = 20
    }
}
