import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterProtocol {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        
    }
    
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Private functions
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadindIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadindIndicator() // скрываем индикатор загрузки
        
        let errorModel = UIAlertController(title: "Что-то пошло не так(", message: message, preferredStyle: .alert)
        errorModel.addAction(UIAlertAction(title: "Попробуйте еще раз", style: .default) { action in
            self.presenter.questionFactory?.loadData()
            self.presenter.questionFactory?.requestNextQuestion()
            self.showLoadingIndicator()
        })
        self.present(errorModel, animated: true, completion: nil)
        
    }
    
    
    func createBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // делаем рамку цветной
    }
    
    func hideBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        counterLabel.text = step.questionNumber
        questionLabel.text = step.question
        imageView.image = step.image
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            self.presenter.resetGame()
            guard let currentQuestion = self.presenter.currentQuestion else {
                return
            }
            self.show(quiz: self.presenter.convert(model: currentQuestion))
        }
        
        showAlert(alertModel: alertModel)
        
    }
    
}
