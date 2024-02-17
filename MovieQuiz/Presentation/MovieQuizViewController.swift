import UIKit

final class MovieQuizViewController: UIViewController{
    
    private var statisticService: StatisticService?
    
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenter?
    
    private var presenter: MovieQuizPresenter!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        //questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        //questionFactory?.loadData()
        alertPresenter = AlertPresenter(view: self)
        presenter = MovieQuizPresenter(viewController: self)
    }

    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var imageView: UIImageView!
    
    //
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
                    self.presenter.showNextQuestionOrResults()
        }
    }
    
    func showAlert(quizResult quiz: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: quiz.title,
                                    message: quiz.text,
                                    buttontext: quiz.buttonText,
                                    buttonAction: {[weak self] in
            self?.presenter.restartGame()
        })
        alertPresenter?.show(data: alertModel)
    }

    func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        if presenter.isLastQuestion() {
            let text = "Вы ответили на \(presenter.correctAnswers) из 10, попробуйте ещё раз!" // ОШИБКА 1: `correctAnswers` не определено
                
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            self.show(quiz: viewModel)
        } else {
            presenter.switchToNextQuestion()
        }
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
               
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.presenter.restartGame()
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
        
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func hideLoadingIndicator() {
          activityIndicator.stopAnimating()
          activityIndicator.isHidden = true
      }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttontext: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alertPresenter?.show(data: model)
    }
}
