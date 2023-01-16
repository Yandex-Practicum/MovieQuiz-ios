import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private var textlabel: UILabel!
    @IBOutlet private var noButtonOutlet: UIButton!
    @IBOutlet private var yesButtonOutlet: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)

        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textlabel.textAlignment = .center
        let noTitle = NSAttributedString(
            string: "Нет",
            attributes: [.font: UIFont(name: "YSDisplay-Medium", size: 20)!]
        )
        noButtonOutlet.setAttributedTitle(noTitle, for: .normal)
        let yesTitle = NSAttributedString(
            string: "Да",
            attributes: [.font: UIFont(name: "YSDisplay-Medium", size: 20)!]
        )
        yesButtonOutlet.setAttributedTitle(yesTitle, for: .normal)
        textlabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - Internal functions
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String, alertPresenter: AlertPresenter) {
        hideLoadingIndicator()
        
        let alertModel: AlertModel = AlertModel(title: "Ошибка!", message: "Картинка не загружена. \(message)", buttonText: "Попробовать ещё раз", completion: { [weak self] in
            guard let self = self else {return}
            self.presenter.restartGame()
        })
        alertPresenter.present(alert: alertModel, presentingViewController: self)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        let attributedText = NSAttributedString(
            string: step.question,
            attributes: [
                .font: UIFont(name: "YSDisplay-Medium", size: 24)!,
                .foregroundColor: UIColor.ypWhite
            ]
        )
        textlabel.attributedText = attributedText
    }
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        noButtonOutlet.isEnabled = false
        yesButtonOutlet.isEnabled = false
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            self.presenter.showNextQuestionOrResults()
            self.noButtonOutlet.isEnabled = true
            self.yesButtonOutlet.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @IBAction private func noButtonTapped(_ sender: UIButton) {
        presenter.noButtonTapped()
    }
    
    @IBAction private func yesButtonTapped(_ sender: UIButton) {
        presenter.yesButtonTapped()
    }
}
