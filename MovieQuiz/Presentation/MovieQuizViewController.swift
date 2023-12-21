import UIKit

final class MovieQuizViewController: UIViewController{
    
    // MARK: - IBOutlet
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - IB Actions
    @IBAction private func yesButtonPressed(_ sender: Any) {
        presenter.currentQuestion = presenter.currentQuestion
        presenter.yesButtonClicked()
    }
    
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        presenter.currentQuestion = presenter.currentQuestion
        presenter.noButtonClicked()
    }
    
    // MARK: - Private Properties
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticServiceImpl?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override final func viewDidLoad() {
        super.viewDidLoad()
        customizationUI()
        presenter = MovieQuizPresenter(viewController:self)
        presenter.viewController = self
        alertPresenter = AlertPresenterImpl(viewController:self)
        statisticService = StatisticServiceImpl()
        showLoadingIndicator()
        presenter.loadMovies()
    }
    
    // MARK: - Public Methods
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    // MARK: - Private functions
    private func customizationUI(){
        view.backgroundColor = UIColor.ypBlack
        
        activityIndicator.color = UIColor.ypBlack
        activityIndicator.transform = CGAffineTransform(scaleX: 3, y: 3)
        
        noButton.setTitle("Нет", for: .normal)
        noButton.setTitleColor(UIColor.ypBlack, for: .normal)
        noButton.backgroundColor = UIColor.ypWhite
        noButton.layer.cornerRadius = 15
        noButton.frame.size = CGSize(width: 157, height: 60)
        
        yesButton.setTitle("Да", for: .normal)
        yesButton.setTitleColor(UIColor.ypBlack, for: .normal)
        yesButton.backgroundColor = UIColor.ypWhite
        yesButton.layer.cornerRadius = 15
        yesButton.frame.size = CGSize(width: 157, height: 60)
        
        textLabel.text = "Вопрос:"
        textLabel.textColor = UIColor.ypWhite
        textLabel.frame.size = CGSize(width: 72, height: 24)
        
        
        counterLabel.textColor = UIColor.ypWhite
        counterLabel.frame.size = CGSize(width: 72, height: 24)
        questionLabel.textColor = UIColor.ypWhite
        questionLabel.frame.size = CGSize(width: 72, height: 24)
        
        imageView.layer.cornerRadius = 20
    }
    
   func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    

    
    func highLightTrueAnswer(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    func showFinalResults(){
        statisticService?.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        let alertModel = AlertModel(
            title: "Игра окончена!",
            message: presenter.makeResultMessage(),
            buttonText: "Сыграть ещё раз",
            buttonAction: {[weak self] in
                self?.presenter.resetQuestionIndex()
                self?.presenter.correctAnswers = 0
                self?.presenter.RequestToShowNextQuestion()
            },
            accessibilityIdentifier: "AlertResult"
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false //
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func updateButtonStates(buttonsEnabled: Bool) {
        yesButton.isEnabled = buttonsEnabled
        noButton.isEnabled = buttonsEnabled
    }
}

