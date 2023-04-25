import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
  
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var questionFactory: QuestionFactory?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        showLoadingIndicator()
        questionFactory?.loadData()
        alertPresenter = AlertPresenterImpl(viewController: self)
        
        statisticService = StatisticServiceImplementation(
            userDefaults: UserDefaults(),
            decoder: JSONDecoder(),
            encoder: JSONEncoder()
        )
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.cornerRadius = 20
    }
    
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
           imageView.layer.masksToBounds = true
           imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
       }
    
    func showFinalResults() {
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: presenter.makeResultMessage(),
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                self?.presenter.restartGame()
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(alertModel: AlertModel)  {
        hideLoadingIndicator()
        let alert = AlertModel(title: "Ошибка",
                                  message: "",
                                  buttonText: "Попробовать еще раз") { [weak self] in
               guard let self = self else { return }
               
            self.presenter.restartGame()
            self.questionFactory?.requestNextQuestion()
           }
           
        self.alertPresenter?.show(alertModel: alert)
    }

}
