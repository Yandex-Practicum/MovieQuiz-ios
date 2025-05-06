import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol  {
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
   
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        presenter.noButtonClicked()
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        presenter.yesButtonClicked()
    }
    
    private var alertPresenterImpl: AlertPresenter?

    private var correctAnswers: Int = 0
    
   func show(quiz step: QuizStepViewModel) {
        noButton.isEnabled = true
        yesButton.isEnabled = true
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        imageView.layer.borderColor = UIColor.clear.cgColor
    
    }
    
    func show(quiz result: QuizResultsViewModel) {
           let message = presenter.makeResultMessage()

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
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    

    override func viewDidLoad() {

        super.viewDidLoad()

        presenter = MovieQuizPresenter(viewController: self)

        imageView.layer.cornerRadius = 20
    }
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func showNetworkError(message: String) {

        hideLoadingIndicator()

               let alert = UIAlertController(
                   title: "Ошибка",
                   message: message,
                   preferredStyle: .alert)

                   let action = UIAlertAction(title: "Попробовать ещё раз",
                   style: .default) { [weak self] _ in
                       guard let self = self else { return }

                       self.presenter.restartGame()
                   }

               alert.addAction(action)
           }
    }
