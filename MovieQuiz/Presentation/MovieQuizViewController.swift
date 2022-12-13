import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol  {
    
        
    // MARK: - Lifecycle

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    
    weak var buttonNo: UIButton!
    weak var buttonYes: UIButton!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        //questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        //statisticService = StatisticServiceImplementation()

        //questionFactory?.loadData()
        showLoadingIndicator()
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
            
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true // скрываем индикатор загрузки

        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Попробовать еще раз",
                                   style: .default) { [weak self] _ in
            guard let self = self else { return }

//            self.presenter.resetQuestionIndex()
//            self.correctAnswers = 0
            self.presenter.restartGame()

            //self.questionFactory?.requestNextQuestion()
        }

        alert.addAction(action)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // MARK: - AlertPresenterDelegate
    
    func didShowAlert(controller: UIAlertController?) {
        guard let controller = controller else {
            return
        }
        present(controller, animated: true, completion: nil)

    }
    
    // MARK: Индикатор загрузки
    
    func hideLoadingIndicator() {
         activityIndicator.isHidden = true
         //activityIndicator.stopAnimating()
     }
    
    
}
