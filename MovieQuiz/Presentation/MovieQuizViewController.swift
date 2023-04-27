import UIKit

final class MovieQuizViewController: UIViewController  {
    
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = 0     //счетчик правильных ответов
    private var currentQuestionIndex = 0    //индекс текущего вопроса
    private let questionsAmount: Int = 10
    private var statisticService: StatisticService?
    private var currentQuestion: QuizQuestion?
    private var presenter: MovieQuizPresenter?
    //    MARK - Button
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingIndicator()
        statisticService = StatisticServiceImplementation()
        presenter = MovieQuizPresenter()
        presenter?.viewDelegate = self
    }
    
    internal func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
        activityIndicator.stopAnimating() // выключаем анимацию
    }
    
    internal func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    //Заполняем счетчик, картинку, текст вопроса данными. Рамку убираем
    internal func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
    }
}

extension MovieQuizViewController: MovieQuizPresenterDelegate {
    func setButtons(enable: Bool) {
        yesButton.isEnabled = enable
        noButton.isEnabled = enable
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func presentController(_ controller: UIViewController, animated: Bool) {
        self.present(controller, animated: animated)
    }

    func show(result: AlertModel) {
        let alert = UIAlertController(title: result.title,      // заголовок всплывающего окна
                                      message: result.message, // текст
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()
        }
        
        alert.addAction(action)
        showAlert(alert)
    }
    
    private func showAlert(_ alert: UIAlertController) {
        presentController(alert, animated: true)
    }
}
