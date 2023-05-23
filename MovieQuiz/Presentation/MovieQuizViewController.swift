import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    // MARK: - Аутлеты и действия

    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }

    //MARK: - Свойства

    private var currentQuestion: QuizQuestion?
    private var presenter: MovieQuizPresenter!


    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
        
    }

    // MARK: - Функции показа

    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0

        setInteractionEnabled(true)
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showResult(present: UIAlertController) {
        self.present(present,animated: true, completion: nil)
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }

    func setInteractionEnabled(_ val: Bool) {
        view.isUserInteractionEnabled = val
    }

    func showNetworkError(message: String) {
        hideLoadingIndicator()

        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else { return }

            self.presenter.questionFactory?.loadData()
            self.presenter.restartGame()
        }
        presenter.showAlert(model)
    }
    
}

