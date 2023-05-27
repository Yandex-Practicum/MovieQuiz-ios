import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    var presenter = MovieQuizPresenter()
    
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenterImpl(viewContoller: self)
        
        imageView.layer.cornerRadius = 20
        presenter.viewController = self
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        activityIndicator.hidesWhenStopped = true
    }
    //MARK: - Prefer White
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - Actions
    
    @IBAction private func YesButton(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func NoButton(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
            
            self.presenter.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(alertModel: model)
    }
    
    func showLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func toggleButtonsInteraction(_ enabled: Bool) {
        yesButton.isUserInteractionEnabled = enabled
        noButton.isUserInteractionEnabled = enabled
    }
    
    func show(quiz viewModel: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            presenter.correctAnswers += 1
        }
        toggleButtonsInteraction(false)
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.borderWidth = 8
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    func showFinalResults() {
        let alertModel = AlertModel(
            title: "Игра окончена",
            message: presenter.makeResultMessage(),
            buttonText: "ОК",
            buttonAction: { [weak self] in
                self?.handleFinalResults()
            }
        )
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { [weak self] _ in
            self?.handleFinalResults()
        }
        let alertController = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func handleFinalResults() {
        presenter.correctAnswers = 0
        presenter.resetQuestionIndex()
    }
}


