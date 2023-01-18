import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
   

    // MARK: - vars and buttons

    private var presenter:MovieQuizPresenter!
    var alertPresenter: AlertPresenterProtocol?
    
    
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var buttonYes: UIButton!
    @IBOutlet private weak var buttonNo: UIButton!

    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        disableMyButtons()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        disableMyButtons()
    }
    
    // MARK: - funcs
    

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
                self.presenter.resetGame()
                }
               alert.addAction(action)
    }
    
    
    

    
    
    private func disableMyButtons() {
        buttonNo.isEnabled = false
        buttonYes.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.buttonNo.isEnabled = true
            self.buttonYes.isEnabled = true
        }
        
        
    }
    
    
    func show(quiz step: QuizStepViewModel) {
           imageView.layer.borderColor = UIColor.clear.cgColor
           imageView.image = step.image
           textLabel.text = step.question
           counterLabel.text = step.questionNumber
       }

    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(controller: self)
        imageView.layer.cornerRadius = 20

        func string(from documentDirectory: URL) throws -> String {
            if !FileManager.default.fileExists(atPath: documentDirectory.path) {
                throw FileManagerError.fileDoesntExist
            }
            return try String(contentsOf: documentDirectory)
        }

        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("top250MoviesIMDB.json")
        let top250MoviesIMDB = try? string(from: fileURL)
        guard let data = top250MoviesIMDB?.data(using: .utf8) else {return}
        
        do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            let result = try? JSONDecoder().decode(Top.self, from: data)
        } catch {
            print("Failed to parse: \(error.localizedDescription)")

        }
        
        
        enum FileManagerError: Error {
            case fileDoesntExist
        }
    }  
}





