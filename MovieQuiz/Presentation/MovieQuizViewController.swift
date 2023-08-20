import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var counerLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter?
    private var alertPresenter: AlertPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        _ = StatisticServiceImplementation()
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        presenter = MovieQuizPresenter(viewController: self, questionFactory: questionFactory, statisticService: StatisticServiceImplementation())
        alertPresenter = AlertPresenter(presentingViewController: self)
        showLoadingIndicator()
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counerLabel.text = step.questionNumber
    }
    
    // Метод для показа результатов раунда квиза
    func show(quiz result: QuizResultsViewModel) {
        if let presenter = presenter {
            let message = presenter.makeResultsMessage()
            let alertModel = AlertModel(
                title: result.title,
                message: message,
                buttonText: result.buttonText,
                completion: { [weak self] in
                    guard self != nil else { return }
                    presenter.restartGame()
                },
                accessibilityIdentifier: "Game results")
            alertPresenter?.presentAlert(with: alertModel)
        }
    }
    // Метод, который меняет цвет рамки
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        if let presenter = self.presenter {
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert)
            let action = UIAlertAction(title: "Попробовать ещё раз",
                                       style: .default) { [weak self] _ in
                guard self != nil else { return }
                presenter.restartGame()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
