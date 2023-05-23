import UIKit

final class MovieQuizViewController: UIViewController {

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
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
}

