import UIKit

final class MovieQuizViewController: UIViewController, QuestionFacotryDelegate, AlertPresenterDelegate {
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var alertModel: AlertModel?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticService = StatisticServiceImplementation()

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 8
//        imageView.layer.borderColor = UIColor.ysBlack.cgColor
        
        alertPresenter = AlertPresenter(delegate: self)
        alertPresenter.delegate = self
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        questionFactory.loadData()
        
        imageView.layer.cornerRadius = 20
        
//        print(NSHomeDirectory()) //файлы которые лежат в приложении
//        UserDefaults.standard.set(true, forKey: "viewDidLoad")
//        print(Bundle.main.bundlePath) //адрес где хранится само приложение
    }
    
    //MARK: - func didLoadDataFromServer
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    //MARK: - func didFailToLoadData
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription) //сообщение описания ошибки
    }
    //MARK: - func showLoadingIndicator
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    //MARK: - func showNetworkError
    private func showNetworkError(message: String) {
//        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonTexts: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.loadData()
            }
        alertPresenter.showAlert(alertModel: model)
    }

    //MARK: - func yesButtonClicked
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else { return }
                
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    //MARK: - func noButtonClicked
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    //MARK: - func didReceiveNextQuestion
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    //MARK: - func convert(model: ... )
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel (
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    //MARK: - func show(quiz step: ... )
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    //MARK: - func show(quiz result: ... )
    private func show(quiz result: QuizResultsViewModel) {
            let alertModel  = AlertModel(title: result.title,
                                         message: result.text,
                                         buttonTexts: result.buttonText,
                                         completions: {[ weak self ] in
                                guard let self = self else {
                                return
        }
                                self.currentQuestionIndex = 0
                                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            })

        alertPresenter.showAlert(alertModel: alertModel)
        }
    
    //MARK: - func showAnswerResult
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ysGreen.cgColor : UIColor.ysRed.cgColor
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in 
            
            self?.showNextQuestionOrResults()
        }
        
    }

    //MARK: - func showAlert
    internal func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }

    //MARK: - func showNextQuestionOrResults
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let quizCount = statisticService.gamesCount
            let bestGame = statisticService.bestGame
            let formAccuracy = "\(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let text = """
                    Ваш результат: \(correctAnswers)/\(questionsAmount)
                    Количество сыгранных раундов: \(quizCount)
                    Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                    Средняя точность: \(formAccuracy)
                    """
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!",
                                                 text: text,
                                                 buttonText: "Сыграть еще раз")
            
            show(quiz: viewModel)
            
        } else {
            currentQuestionIndex += 1

            self.questionFactory?.requestNextQuestion()
        }
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        func showAlert(quiz result: AlertModel) {
            let alert = UIAlertController(
                title: result.title,
                message: result.message,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: result.buttonTexts, style: .default) { [weak self] _ in
                
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                questionFactory?.requestNextQuestion()
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
